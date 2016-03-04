class LocationMenusController < ApplicationController
  load_and_authorize_resource
  def index
  	@location_menus = LocationMenu.where('location_id', params[:location_id])
  end

  def edit
  end

  def update
    @location_menu = LocationMenu.find(params[:id])

    respond_to do |format|
      if @location_menu.update_attributes(params[:location_menu])
        format.html { redirect_to @location_menu, notice: 'Menu was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
  	@location_menu = LocationMenu.new(params[:location_menu])

    respond_to do |format|
      if @location_menu.save
        format.html { redirect_to @location_menu, notice: 'Menu was successfully created.' }
        format.json { render json: @location_menu, status: :created, location: @location_menu }
      else
        format.html { render action: "new" }
        format.json { render json: @location_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @location_menu = LocationMenu.find(params[:id])
    @location_menu.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
