class ServicesController < ApplicationController
  load_resource :location
  load_and_authorize_resource :service, through: [:location]

  # GET /services
  # GET /services.json
  def index
    @services = @location.services

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @services }
    end
  end

  # GET /services/1
  # GET /services/1.json
  def show
    @service = Service.find(params[:id])

    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb @service.location.district.name, district_guide_path(@service.location.district) if @service.location.district
    add_crumb @service.location.neighborhood.name if @service.location.neighborhood
    add_crumb @service.location.broker.name, "#{@base_path}business/#{@service.location.broker.slug}" if @service.location.broker.present?
    add_crumb @service.location.name, "#{@base_path}business/#{@service.location.slug}"
    add_crumb @service.name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @service }
    end
  end

  # GET /services/new
  # GET /services/new.json
  def new
    @service = @location.services.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @service }
    end
  end

  # GET /services/1/edit
  def edit
    @service = Service.find(params[:id])
  end

  # POST /services
  # POST /services.json
  def create
    @service = @location.services.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to @location, notice: 'Service was successfully created.' }
        format.json { render json: @service, status: :created, location: @service }
      else
        format.html { render action: "new" }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.json
  def update
    @service = Service.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(service_params)
        format.html { redirect_to @location, notice: 'Service was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to location_services_url }
      format.json { head :no_content }
    end
  end

  private

  def service_params
    params.require(:service).permit(:description, :name, :sku, :slug, :location_id, :image, :price)
  end
end
