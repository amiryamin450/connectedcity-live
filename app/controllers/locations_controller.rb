class LocationsController < ApplicationController
  load_and_authorize_resource
  PER_PAGE = 20
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
    @location_menus = Location.includes(:location_menus).find(params[:id])

    # because we have two sources for the location carousel images (cover photo and location images),
    # get them into one collection for ease of display
    @location_carousel_images = @location.location_images.collect{ |li| li.image }
    @location_carousel_images.unshift(@location.cover_photo) if @location.cover_photo.exists?

    @location_menu_images = @location_menus.location_menus.collect{ |location_menu| location_menu.image }

    @is_location_normal = @location.hall_id.blank? && @location.councillor_id.blank? && @location.commissioner_id.blank?
    @is_municipality = !@is_location_normal || @location.slug === 'city-of-vancouver'
    if (@is_location_normal)
      lproducts = @location.products
      @status_updates = @location.status_updates.page(params[:status_page]).per(7)
      @articles = @location.news_articles.page(params[:article_page]).per(5)
      @blog_entries = @location.blog_entries.page(params[:blog_page]).per(5)
      @products = lproducts.order('created_at DESC').limit(20)
      @services = @location.services.page(params[:service_page]).per(12)
      @coupons = @location.coupons.page(params[:coupon_page]).per(12)
      @media_attachments = @location.media_attachments.order('created_at DESC').limit(20)
      @events = @location.events.page(params[:event_page]).per(12)
      @listings = @location.real_estate_listings.page(params[:listing_page]).per(12)
      @auto_listings = @location.automotive_listings.page(params[:auto_listing_page]).per(12) if @location.vertical_market_categories.exists?(40)

      @rental_properties = @location.rental_properties.page(params[:rental_page]).per(12) if @location.vertical_market_categories.exists?(101)
      @new_home_communities = @location.new_home_communities.page(params[:communities_page]).per(12) if @location.vertical_market_categories.exists?(102)

      # TODO - should only happen if user is logged in and can post a status update
      @status_update = @location.status_updates.build
      @status_update.social_profile_ids = @location.social_profiles.pluck(:id).map(&:to_s)
      category_ids = lproducts.group_by { |a| a.category_id.itself }.keys
      category_ids.delete_at(category_ids.index(0)) if category_ids.include?(0)
      @categories = Category.where(id: category_ids).order(:name)
      @category_id = 'all'
    else
      @media_attachments = @location.media_attachments.order('created_at DESC').limit(PER_PAGE)
      @status_updates = @location.status_updates.where(statusable_type: 'Location').limit(PER_PAGE)
      @articles = @location.news_articles.limit(PER_PAGE)
      @events = @location.events.order(:starts_at).limit(PER_PAGE)
    end

    @vertical_market = @location.vertical_market_categories.first.vertical_market if @location.vertical_market_categories.size > 0
    if [164, 174].include?(@vertical_market.id)
      names = @vertical_market.id === 164 ? 'Provincial Updates' : 'Federal Updates'
      @categories_news = Category.where(name: names)
    end

    cookies[:return_to] = "#{@base_path}business/#{@location.slug}"


    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb @location.district.name, district_guide_path(@location.district.name) if @location.district
    add_crumb @location.neighborhood.name if @location.neighborhood
    add_crumb @location.sub_neighborhood.name if @location.sub_neighborhood

    @vertical_market.ancestors.each do |ancestor|
      add_crumb ancestor.name, "#{@base_path}guide/#{ancestor.slug}"
    end

    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}" if @vertical_market

    add_crumb @location.broker.name, "#{@base_path}business/#{@location.broker.slug}" if @location.broker.present?
    add_crumb @location.name
    respond_to do |format|
      format.html {render layout: "application_v_2"}
      format.json { render json:  @location.location_images.map{|file| file.to_jq_upload }.to_json(include: :location_images)  }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    if (params[:broker_id].present? )
      @location = Location.find(params[:broker_id]).agents.new
      @vertical_market_categories = categories_without_municipality
    elsif params[:hall_id].present?
      @location = Location.find(params[:hall_id]).city_halls.new
      @vertical_market_categories = VerticalMarketCategory.where(name: name_vertical_categories)
      @location.vertical_market_categories = [@vertical_market_categories.first]
    elsif params[:councillor_id].present?
      @location = Location.find(params[:councillor_id]).city_councillors.new
      @vertical_market_categories = VerticalMarketCategory.where(slug: 'city-councillors')
      @location.vertical_market_categories = @vertical_market_categories
    elsif params[:commissioner_id].present?
      @location = Location.find(params[:commissioner_id]).park_recreation_commissioners.new
      @vertical_market_categories = VerticalMarketCategory.where(slug: 'parks-recreation-commissioners')
      @location.vertical_market_categories = @vertical_market_categories
    else
      @location = Location.new
      @vertical_market_categories = categories_without_municipality

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

    @location = Location.find(params[:id])
    if @location.hall_id.present?
      @vertical_market_categories = VerticalMarketCategory.where(name: name_vertical_categories)
    elsif @location.councillor_id.present?
      @vertical_market_categories = VerticalMarketCategory.where(slug: 'city-councillors')
    elsif @location.commissioner_id.present?
      @vertical_market_categories = VerticalMarketCategory.where(slug: 'parks-recreation-commissioners')
    else
      @vertical_market_categories = categories_without_municipality
    end
    cookies[:return_to] ||= request.referer

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
        pr = params[:location]

        if pr[:hall_id].present?
          @vertical_market_categories = VerticalMarketCategory.where(name: name_vertical_categories)
        elsif pr[:councillor_id].present?
          @vertical_market_categories = VerticalMarketCategory.where(slug: 'city-councillors')
        elsif pr[:commissioner_id].present?
          @vertical_market_categories = VerticalMarketCategory.where(slug: 'parks-recreation-commissioners')
        else
          @vertical_market_categories = categories_without_municipality
        end

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

        # format.html { render action: "edit" }
        format.html { redirect_to edit_location_path }
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
    @location.stripe_plan_id = 'yearly-new'
  end

  def claim_process
    @location = Location.find(params[:id])
    @location.assign_attributes params[:location].slice(:stripe_plan_id)
    @location.payment_user = current_user

    begin
      if @location.payment_user.stripe_customer_id
        customer = Stripe::Customer.retrieve @location.payment_user.stripe_customer_id
      else
        customer = Stripe::Customer.create email: @location.payment_user.email

        @location.payment_user.stripe_customer_id = customer.id
        @location.payment_user.save validate: false
      end
    rescue => e
      flash[:error] = e.message
      return render :claim
    end

    begin
      subscription = customer.subscriptions.create plan: @location.stripe_plan_id,
                                                   source: params[:stripeToken]

      @location.stripe_subscription_id = subscription.id
      @location.users << current_user
      @location.save validate: false

      LocationMailer.claim_approved_email(@location, current_user).deliver

      redirect_to connected_advertiser_location_path(@location)
    rescue => e
      flash[:error] = e.message
      return render :claim
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
    @location.claim_pending = false
    @location.user_ids = nil
    @location.stripe_plan_id = nil
    @location.stripe_subscription_id = nil
    @location.payment_user = nil

    if @location.stripe_subscription_id
      begin
        customer = Stripe::Customer.retrieve @location.payment_user.stripe_customer_id
        customer.subscriptions.retrieve(@location.stripe_subscription_id).delete
      rescue
      end
    end

    @location.save
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

  def export
    respond_to do |format|
      format.any {
        location_attributes = ['id', 'name', 'address', 'address_1', 'postal_code', 'phone']
        neighborhood_attributes = ['nid', 'neighborhd']
        vertical_market_attributes = ['id', 'name']
        vertical_market_category_attributes = ['id', 'name']

        data = CSV.generate(headers: true) do |csv|
          csv << location_attributes + ['neighborhood', 'vertical_market', 'vertical_market_category'].map { |a| eval("#{a}_attributes").map { |b| "#{a}_#{b}" } }.flatten

          Location.includes(:neighborhood).select(location_attributes + neighborhood_attributes.map { |a| "neighborhoods.#{a}" }).limit(30).each do |location|
            vertical_market_category = location.vertical_market_categories.first

            csv << location_attributes.map { |a| location.send(a).presence } +
                   neighborhood_attributes.map { |a| location.neighborhood.send(a).presence if location.neighborhood } +
                   vertical_market_attributes.map { |a| vertical_market_category.send(a).presence if vertical_market_category } +
                   vertical_market_category_attributes.map { |a| vertical_market_category.vertical_market.send(a).presence if vertical_market_category }
          end
        end

        send_data data, filename: 'businesses.csv', type: 'text/csv', disposition: :attachment
      }
    end
  end

  def name_vertical_categories
    [
      'Mayor',
      'Deputy Major',
      'City Manager',
      'Deputy City Manager',
      'Chief Financial Officer',
      'Police Chief',
      'Fire Chief',
      'Director of Economic Development',
      'Director of City Planning',
      'Director of Public Works',
      'Chief Human Resources Officer',
      'Chief Legal Officer',
      'General Manager - Art, Culture & Community',
      'General Manager - Buildings, Development & Listings',
      'General Manager - Engineering Services',
      'Chief Communications Officer'
    ]
  end

  def name_vertical_categories_others
    [
      'City Councillors',
      'Parks & Recreation Commissioners'
    ]
  end

  def categories_without_municipality
    name_categories = name_vertical_categories + name_vertical_categories_others
    VerticalMarketCategory.where("name NOT IN (?)", name_categories).order(:name)
  end
  
  def get_provinces_by_country
    if params[:country_slug]
      @country = Country.find_by_id(params[:country_slug])
      render json: @country.provinces
    else
      render json: []
    end
  end

  def get_cities_by_province
    if params[:province_slug]
      @province = Province.find_by_id(params[:province_slug])
      render json: @province.cities
    else
      render json: []
    end
  end

  def get_districts_by_city
    if params[:city_slug]
      @city = City.find_by_id(params[:city_slug])
      render json: @city.districts
    else
      render json: []
    end
  end

  def get_neighborhoods_by_district
    if params[:district_slug]
      @district = District.find_by_id(params[:district_slug])
      render json: @district.neighborhoods
    else
      render json: []
    end
  end

  def get_sub_neighborhoods_by_neighborhood
    if params[:neighborhood_slug]
      @sub_neighborhood = Neighborhood.where(neighborhood_id: params[:neighborhood_slug])
      render json: @sub_neighborhood
    else
      render json: []
    end
  end
end
