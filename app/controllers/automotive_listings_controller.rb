class AutomotiveListingsController < ApplicationController
  before_action :set_location
  before_action :automotive_listing, only: [:show, :edit, :update, :destroy, :delete_main_image, :delete_sub_image]
  load_resource :location
  load_and_authorize_resource :automotive_listing, through: [:location]
  layout "application_v_2"

  # GET /automotive_listings
  # GET /automotive_listings.json
  def index
    @automotive_listings = @location.automotive_listings

    respond_to do |format|
      format.html
      format.json { render json: @automotive_listings }
    end
  end

  # GET /automotive_listings/1
  # GET /automotive_listings/1.json
  def show
    @vertical_market = @location.vertical_market_categories.first.vertical_market

    add_breadcrumb '<i class="icon-home"></i> Home'.html_safe, root_path

    province, region, municipality, city, district, neighborhood, sub_neighborhood = @location.full_address

    add_breadcrumb municipality.name, "/#{province.slug}/#{region.slug}/#{municipality.slug}" if municipality.present?

    add_breadcrumb city.name, "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}" if city.present?

    add_breadcrumb district.name, "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}" if district.present?

    add_breadcrumb neighborhood.name, "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}/#{neighborhood.slug}" if neighborhood.present?

    add_breadcrumb sub_neighborhood.name, "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}/#{neighborhood.slug}/#{sub_neighborhood}" if sub_neighborhood.present?

    add_breadcrumb @vertical_market.name, "/vancouver/channel/#{@vertical_market.slug}"

    add_breadcrumb @location.vertical_market_categories.first.name, "/vancouver/category/#{@location.vertical_market_categories.first.slug}"

    add_breadcrumb @location.name, "/business/#{@location.slug}"

    add_breadcrumb @automotive_listing.title

    @images = [@automotive_listing.main_image] + @automotive_listing.sub_images.map(&:image)

    respond_to do |format|
      format.html
      format.json { render json: @automotive_listing }
    end
  end

  # GET /automotive_listings/new
  # GET /automotive_listings/new.json
  def new
    @automotive_listing = @location.automotive_listings.new
    @auto_makers = get_auto_makers
    respond_to do |format|
      format.html
      format.json { render json: @automotive_listing }
    end
  end

  # GET /automotive_listings/1/edit
  def edit
    @auto_makers = get_auto_makers
    @selected_maker = @automotive_listing.make
  end

  # POST /automotive_listings
  # POST /automotive_listings.json
  def create
    @automotive_listing = @location.automotive_listings.new(automative_listing_params)

    respond_to do |format|
      if @automotive_listing.save
        format.html { redirect_to [@location, @automotive_listing], notice: 'Automotive listing was successfully created.' }
        format.json { render json: @automotive_listing, status: :created, location: @automotive_listing }
      else
        format.html { render action: "new" }
        format.json { render json: @automotive_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /automotive_listings/1
  # PUT /automotive_listings/1.json
  def update
    @auto_makers = get_auto_makers
    @selected_maker = @automotive_listing.make

    respond_to do |format|
      if @automotive_listing.update(automative_listing_params)
        format.html { redirect_to [@location, @automotive_listing], notice: 'Automotive listing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @automotive_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /automotive_listings/1
  # DELETE /automotive_listings/1.json
  def destroy
    @automotive_listing.destroy

    respond_to do |format|
      format.html { redirect_to location_automotive_listings_url }
      format.json { head :no_content }
    end
  end

  def delete_main_image
    if @automotive_listing.main_image.destroy
      @auto_makers = get_auto_makers
      respond_to do |format|
        format.js { render 'delete_image' }
      end
    end
  end

  def delete_sub_image
    image = @automotive_listing.sub_images.find(params[:image_id])

    if image.delete
      @auto_makers = get_auto_makers

      respond_to do |format|
        format.js { render 'delete_image' }
      end
    end
  end

  private

  def set_location
    @location = Location.friendly.find(params[:location_id])
  end

  def automotive_listing
    @automotive_listing = AutomotiveListing.find(params[:id])
  end

  def automative_listing_params
    params.require(:automotive_listing).permit(
      :accident, :body, :body_exterior, :convenience_features, :description,
      :drivetrain, :enigine, :entertainment_features, :exterior_color, :interior_color,
      :lighting_visibility_instruments, :local, :location_id, :make, :mileage, :model,
      :powertrain_specs, :price_cents, :saftey_and_security, :seats_and_trim, :specs,
      :status, :stock_number, :suspension_specs, :title, :transmission, :trim_level, :vehicle_type,
      :year, :price, :accident_description, :main_image, sub_images_attributes: [:image]
    )
  end

  def get_auto_makers
  	["Acura",
    "Alfa Romeo",
    "Aston Martin",
    "Audi",
    "BMW",
    "Bentley",
    "Bugatti",
    "Buick",
    "Cadillac",
    "Chevrolet",
    "Chrysler",
    "Dodge",
    "Ferrari",
    "Fiat",
    "Fisker",
    "Ford",
    "GMC",
    "Honda",
    "Hummer",
    "Hyundai",
    "Infiniti",
    "Jaguar",
    "Jeep",
    "Kia",
    "Lamborghini",
    "Land Rover",
    "Lexus",
    "Lotus",
    "MG",
    "Maserati",
    "Maybach",
    "Mazda",
    "McLaren",
    "Mercedes-Benz",
    "Mini",
    "Mitsubishi",
    "Nissan",
    "Peugeot",
    "Pontiac",
    "Porsche",
    "Renault",
    "Rolls-Royce",
    "Saab",
    "Scion",
    "Smart",
    "Subaru",
    "Suzuki",
    "Tesla",
    "Toyota",
    "Volkswagen",
    "Volvo"
    ]
  end
end
