class RentalUnitsController < ApplicationController
  load_and_authorize_resource :location
  load_and_authorize_resource :rental_property
  load_and_authorize_resource :rental_unit

  # GET /rental_units
  # GET /rental_units.json
  def index
    @rental_units = @rental_property.rental_units

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rental_units }
    end
  end

  # GET /rental_units/1
  # GET /rental_units/1.json
  def show

    @vertical_market = @location.vertical_market_categories.first.vertical_market


    add_crumb @district.name, district_guide_path(@district) if @district
    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}"
    add_crumb @location.vertical_market_categories.first.name, "#{@base_path}category/#{@location.vertical_market_categories.first.slug}"
    add_crumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_crumb @rental_property.name, "/business/#{@location.slug}/rental_properties/#{@rental_property.slug}"
    add_crumb "Unit: #{@rental_unit.unit_number}"




    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rental_unit }
    end
  end

  # GET /rental_units/new
  # GET /rental_units/new.json
  def new
    @rental_unit = @rental_property.rental_units.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rental_unit }
    end
  end

  # GET /rental_units/1/edit
  def edit
    @rental_unit = RentalUnit.find(params[:id])
  end

  # POST /rental_units
  # POST /rental_units.json
  def create
    @rental_unit = @rental_property.rental_units.new(rental_unit_params)

    respond_to do |format|
      if @rental_unit.save
        format.html { redirect_to [@location, @rental_property, @rental_unit], notice: 'Rental unit was successfully created.' }
        format.json { render json: @rental_unit, status: :created, location: @rental_unit }
      else
        format.html { render action: "new" }
        format.json { render json: @rental_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rental_units/1
  # PUT /rental_units/1.json
  def update
    @rental_unit = RentalUnit.find(params[:id])

    respond_to do |format|
      if @rental_unit.update_attributes(rental_unit_params)
        format.html { redirect_to [@location, @rental_property, @rental_unit], notice: 'Rental unit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rental_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rental_units/1
  # DELETE /rental_units/1.json
  def destroy
    @rental_unit = RentalUnit.find(params[:id])
    @rental_unit.destroy

    respond_to do |format|
      format.html { redirect_to rental_units_url }
      format.json { head :no_content }
    end
  end

  private

  def rental_unit_params
    params.require(:rental_unit).permit(:availability, :bathrooms, :bedrooms, :date_available, :description,
      :flooring_types, :included_appliances, :living_area, :property_id, :rent_amount, :unit_number,
      :rental_property, :rental_property_id, :cover_photo)
  end
end
