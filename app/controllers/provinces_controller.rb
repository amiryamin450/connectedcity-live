class StateOrProvincesController < ApplicationController
  load_and_authorize_resource
  layout "admin"

  # GET /state_or_provinces
  # GET /state_or_provinces.json
  def index
    @provinces = StateOrProvince.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @provinces }
    end
  end

  # GET /state_or_provinces/1
  # GET /state_or_provinces/1.json
  def show
    @province = StateOrProvince.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @province }
    end
  end

  # GET /state_or_provinces/new
  # GET /state_or_provinces/new.json
  def new
    @province = StateOrProvince.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @province }
    end
  end

  # GET /state_or_provinces/1/edit
  def edit
    @province = StateOrProvince.find(params[:id])
  end

  # POST /state_or_provinces
  # POST /state_or_provinces.json
  def create
    @province = StateOrProvince.new(province_params)

    respond_to do |format|
      if @province.save
        format.html { redirect_to @province, notice: 'State or province was successfully created.' }
        format.json { render json: @province, status: :created, location: @province }
      else
        format.html { render action: "new" }
        format.json { render json: @province.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /state_or_provinces/1
  # PUT /state_or_provinces/1.json
  def update
    @province = StateOrProvince.find(params[:id])

    respond_to do |format|
      if @province.update_attributes(province_params)
        format.html { redirect_to @province, notice: 'State or province was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @province.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /state_or_provinces/1
  # DELETE /state_or_provinces/1.json
  def destroy
    @province = StateOrProvince.find(params[:id])
    @province.destroy

    respond_to do |format|
      format.html { redirect_to state_or_provinces_url }
      format.json { head :no_content }
    end
  end

  private

  def province_params
    params.require(:province).permit(:name, :abbr, :country_code, :country_name, :province_code)
  end
end
