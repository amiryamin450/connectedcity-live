class RentalPropertiesController < ApplicationController
  before_filter do
    @rental_property = RentalProperty.find(params[:rental_property_id]) if params[:rental_property_id]
  end

  load_and_authorize_resource :location
  load_and_authorize_resource :rental_property, through: [:location]

  # GET /rental_properties
  # GET /rental_properties.json
  def index
    @rental_properties = @location.rental_properties
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rental_properties }
    end
  end

  # GET /rental_properties/1
  # GET /rental_properties/1.json
  def show

   @vertical_market = @location.vertical_market_categories.first.vertical_market

    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path

    # FIXME Cities don't currently work but should be part of the breadcrumbs.
    #       Once support for more than once city has been added, fix this.
    add_crumb @city.name, root_path if @city
    add_crumb @location.district.name, district_guide_path(@location.district) if @location.district
    add_crumb @location.neighborhood.name if @location.neighborhood

    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}"
    add_crumb @location.vertical_market_categories.first.name, "#{@base_path}category/#{@location.vertical_market_categories.first.slug}"
    add_crumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_crumb @rental_property.name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rental_property }
    end
  end

  # GET /rental_properties/new
  # GET /rental_properties/new.json
  def new
    @rental_property = @location.rental_properties.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rental_property }
    end
  end

  # GET /rental_properties/1/edit
  def edit

  end

  # POST /rental_properties
  # POST /rental_properties.json
  def create
    @rental_property = @location.rental_properties.new(params[:rental_property])

    respond_to do |format|
      if @rental_property.save
        format.html { redirect_to [@location, @rental_property], notice: 'Rental property was successfully created.' }
        format.json { render json: @rental_property, status: :created, location: @rental_property }
      else
        format.html { render action: "new" }
        format.json { render json: @rental_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rental_properties/1
  # PUT /rental_properties/1.json
  def update
    @rental_property = RentalProperty.find(params[:id])

    respond_to do |format|
      if @rental_property.update_attributes(params[:rental_property])
        format.html { redirect_to [@location, @rental_property], notice: 'Rental property was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rental_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rental_properties/1
  # DELETE /rental_properties/1.json
  def destroy
    @rental_property = RentalProperty.find(params[:id])
    @rental_property.destroy

    respond_to do |format|
      format.html { redirect_to rental_properties_url }
      format.json { head :no_content }
    end
  end

  def destroy_status_update
    @status_update = StatusUpdate.find(params[:id])
    @status_update.destroy

    redirect_to :back
  end
end
