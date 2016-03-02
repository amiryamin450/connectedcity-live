class LocationsController < ApplicationController
  load_and_authorize_resource except: :claim

  layout 'location', :only => [:show]

  def index

    @search = Location.search(params[:q])
    @locations = @search.result.order(:name).page(params[:page])

    respond_to do |format|
      format.html
    end
  end

  def show
    @location = Location.includes(:location_images).find(params[:id])
    @location_menus = Location.includes(:location_menu).find(params[:id])

    # because we have two sources for the location carousel images (cover photo and location images),
    # get them into one collection for ease of display
    @location_carousel_images = @location.location_images.collect{ |li| li.image }
    @location_carousel_images.unshift(@location.cover_photo) if @location.cover_photo.exists?

    @location_menu_images = @location_menus.location_menu.collect{ |location_menu| location_menu.image }

    @status_updates = @location.status_updates.page(params[:status_page]).per(7)
    @articles = @location.news_articles.page(params[:article_page]).per(5)
    @blog_entries = @location.blog_entries.page(params[:blog_page]).per(5)
    @products = @location.products.page(params[:product_page]).per(12)
    @coupons = @location.coupons.page(params[:coupon_page]).per(12)
    @media_attachments = @location.media_attachments.page(params[:media_page]).per(12)
    @services = @location.services.page(params[:service_page]).per(12)
    @events = @location.events.page(params[:event_page]).per(12)
    @listings = @location.real_estate_listings.page(params[:listing_page]).per(12)
    @auto_listings = @location.automotive_listings.page(params[:auto_listing_page]).per(12) if @location.vertical_market_categories.exists?(40)

    @rental_properties = @location.rental_properties.page(params[:rental_page]).per(12) if @location.vertical_market_categories.exists?(101)
    @new_home_communities = @location.new_home_communities.page(params[:communities_page]).per(12) if @location.vertical_market_categories.exists?(102)

    # TODO - should only happen if user is logged in and can post a status update
    @status_update = @location.status_updates.build
    @status_update.social_profile_ids = @location.social_profiles.pluck(:id).map(&:to_s)

    @vertical_market = @location.vertical_market_categories.first.vertical_market if @location.vertical_market_categories.size > 0

    cookies[:return_to] = "#{@base_path}business/#{@location.slug}"


    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb @location.district.name, district_guide_path(@location.district.name) if @location.district
    add_crumb @location.neighborhood.name if @location.neighborhood

    @vertical_market.ancestors.each do |ancestor|
      add_crumb ancestor.name, "#{@base_path}guide/#{ancestor.slug}"
    end

    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}" if @vertical_market

    add_crumb @location.broker.name, "#{@base_path}business/#{@location.broker.slug}" if @location.broker.present?
    add_crumb @location.name
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json:  @location.location_images.map{|file| file.to_jq_upload }.to_json(include: :location_images)  }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new

    if (params[:broker_id].present? )
      @location = Location.find(params[:broker_id]).agents.new
      @location.vertical_market_categories = [VerticalMarketCategory.find(99)]
    else
      @location = Location.new

      OperatingHour.days.keys.each do |day|
        @location.operating_hours.build day: day
      end
    end

    # 3.times { @location.location_images.build }
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/1/edit
  def edit

    cookies[:return_to] ||= request.referer
    @location = Location.find(params[:id])

    unless @location.operating_hours.any?
      OperatingHour.days.keys.each do |day|
        @location.operating_hours.build day: day
      end
    end

    @managers = @location.managers.includes(:user)
    add_crumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_crumb "Editing #{@location.name}"
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to cookies[:return_to].present? ? cookies[:return_to] : @location, notice: 'Location was successfully updated.' }
        format.json { render json: { files: [@location.location_images.last.to_jq_upload]}, status: :created, location: @location }
      else
        puts params[:location].to_yaml
        puts @location.errors.to_yaml

        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def claim
    @location = Location.find(params[:id])
    if current_user
      @location.users << current_user
      @location.claim_pending = 1
      if @location.save
        LocationMailer.pending_claim_email(@location, current_user).deliver
      end
      redirect_to @location
    end
  end

  def approve_claim
    @location = Location.find(params[:id])
    @location.claim_pending = 0
    if @location.save
      LocationMailer.claim_approved_email(@location, @location.users.first).deliver
    end
    redirect_to pending_claims_locations_path
  end

  def reject_claim
    @location = Location.find(params[:id])
    user = @location.users.first
    @location.users.destroy_all
    @location.claim_pending = 0
    if @location.save
      LocationMailer.claim_rejected_email(@location, user).deliver
    end
    redirect_to pending_claims_locations_path
  end

  def release
    @location = Location.find(params[:id])
    @location.users.destroy_all
    redirect_to @location
  end

  def pending_claims
    @locations = Location.all(:conditions => { :claim_pending => 1})

    respond_to do |format|
      format.html
    end
  end

  def connected_advertiser
    @location = Location.find(params[:id])
  end

  def import
    @location = ImportRequest.new kind: "businesses"
  end

  def do_import
    request = ImportRequest.new params[:import_request]

    unless request.valid?
      @location = request
      return render action: :import
    end

    @response = ImportService.new(request).import!
    if !@response.success?
      @location = request
      render action: "import"
    end
  end
end
