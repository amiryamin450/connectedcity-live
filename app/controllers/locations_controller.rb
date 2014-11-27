class LocationsController < ApplicationController
  load_and_authorize_resource
  
  layout 'location', :only => [:show]
  # GET /locations
  # GET /locations.json
  def index

    @search = Location.search(params[:q])
    @locations = @search.result.order(:name).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      # format.json { render json: @locations.where("name like ?", "%#{params[:q]}%") }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show



    @location = Location.includes(:location_images).find(params[:id])
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


    @vertical_market = @location.vertical_market_categories.first.vertical_market if @location.vertical_market_categories.size > 0

    cookies[:return_to] = "#{@base_path}business/#{@location.slug}"


    add_crumb @district.name, district_guide_path(@district) if @district
    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}" if @vertical_market
    # add_crumb @location.vertical_market_categories.first.name, "#{@base_path}category/#{@location.vertical_market_categories.first.slug}"
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
      @location.user = current_user
      @location.save
      redirect_to @location
    end
  end

  def release
    @location = Location.find(params[:id])
    @location.user = nil
    @location.save
    redirect_to @location
  end

end
