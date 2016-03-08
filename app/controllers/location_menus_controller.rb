class LocationMenusController < ApplicationController
  load_resource :location
  load_and_authorize_resource :location_menu, through: [:location]

  def index
    #@location_menus = LocationMenu.where('location_id', params[:location_id])
    @location_menus = @location.location_menus
  end

  def edit
    @location_menu = LocationMenu.find(params[:id])
  end

  def new
    @location_menu = @location.location_menus.new
  end

  def create
    @location_menu = @location.location_menus.new(params[:location_menu])

    if @location_menu.save
      redirect_to @location, notice: 'Menu was successfully created.'      
    else
      render action: "new"
    end
  end

  def update
    @location_menu = LocationMenu.find(params[:id])

    if @location_menu.update_attributes(params[:location_menu])
      redirect_to [@location, @location_menu], notice: 'Menu was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @location_menu.destroy
    redirect_to location_location_menus_url
  end
end
