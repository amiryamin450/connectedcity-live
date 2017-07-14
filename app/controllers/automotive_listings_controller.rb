class AutomotiveListingsController < ApplicationController
  load_resource :location
  load_and_authorize_resource :automotive_listing, through: [:location]
  # GET /automotive_listings
  # GET /automotive_listings.json
  def index
    @automotive_listings = @location.automotive_listings

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @automotive_listings }
    end
  end

  # GET /automotive_listings/1
  # GET /automotive_listings/1.json
  def show

   @vertical_market = @location.vertical_market_categories.first.vertical_market


    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb @location.district.name, district_guide_path(@location.district) if @location.district
    add_crumb @location.neighborhood.name if @location.neighborhood

    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}"
    add_crumb @location.vertical_market_categories.first.name, "#{@base_path}category/#{@location.vertical_market_categories.first.slug}"
    add_crumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_crumb @automotive_listing.title

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @automotive_listing }
    end
  end

  # GET /automotive_listings/new
  # GET /automotive_listings/new.json
  def new
    @automotive_listing = @location.automotive_listings.new
	@auto_makers = get_auto_makers
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @automotive_listing }
    end
  end

  # GET /automotive_listings/1/edit
  def edit
	@automotive_listing = AutomotiveListing.find(params[:id])
	@auto_makers = get_auto_makers
	@selected_maker = @automotive_listing.make
  end

  # POST /automotive_listings
  # POST /automotive_listings.json
  def create
    @automotive_listing = @location.automotive_listings.new (params[:automotive_listing])

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
    @automotive_listing = AutomotiveListing.find(params[:id])
	@auto_makers = get_auto_makers
	@selected_maker = @automotive_listing.make

    respond_to do |format|
      if @automotive_listing.update_attributes(params[:automotive_listing])
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
    @automotive_listing = AutomotiveListing.find(params[:id])
    @automotive_listing.destroy

    respond_to do |format|
      format.html { redirect_to location_automotive_listings_url }
      format.json { head :no_content }
    end
  end

  private

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
