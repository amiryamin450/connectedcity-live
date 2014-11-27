class BusinessImprovementAreasController < ApplicationController
  load_and_authorize_resource
  # GET /business_improvement_areas
  # GET /business_improvement_areas.json
  def index
    @business_improvement_areas = BusinessImprovementArea.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @business_improvement_areas }
    end
  end

  # GET /business_improvement_areas/1
  # GET /business_improvement_areas/1.json
  def show
    @business_improvement_area = BusinessImprovementArea.find(params[:id])
    @status_updates = @business_improvement_area.status_updates + @business_improvement_area.location_status_updates
    @tag_cloud = @business_improvement_area.vertical_market_categories.map { |vm| { text: vm.name, weight: vm.locations.where(business_improvement_area_id: @business_improvement_area.id).size, link: vertical_market_category_path(vm) }}.compact
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @business_improvement_area }
    end
  end

  # GET /business_improvement_areas/new
  # GET /business_improvement_areas/new.json
  def new
    @business_improvement_area = BusinessImprovementArea.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @business_improvement_area }
    end
  end

  # GET /business_improvement_areas/1/edit
  def edit
    @business_improvement_area = BusinessImprovementArea.find(params[:id])
  end

  # POST /business_improvement_areas
  # POST /business_improvement_areas.json
  def create
    @business_improvement_area = BusinessImprovementArea.new(params[:business_improvement_area])

    respond_to do |format|
      if @business_improvement_area.save
        format.html { redirect_to @business_improvement_area, notice: 'Business improvement area was successfully created.' }
        format.json { render json: @business_improvement_area, status: :created, location: @business_improvement_area }
      else
        format.html { render action: "new" }
        format.json { render json: @business_improvement_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /business_improvement_areas/1
  # PUT /business_improvement_areas/1.json
  def update
    @business_improvement_area = BusinessImprovementArea.find(params[:id])

    respond_to do |format|
      if @business_improvement_area.update_attributes(params[:business_improvement_area])
        format.html { redirect_to @business_improvement_area, notice: 'Business improvement area was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @business_improvement_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /business_improvement_areas/1
  # DELETE /business_improvement_areas/1.json
  def destroy
    @business_improvement_area = BusinessImprovementArea.find(params[:id])
    @business_improvement_area.destroy

    respond_to do |format|
      format.html { redirect_to business_improvement_areas_url }
      format.json { head :no_content }
    end
  end
end
