class LocationMenusController < ApplicationController
  before_action :find_location, only: [:index, :create, :edit, :update, :show]
  load_resource :location
  load_and_authorize_resource :location_menu, through: [:location]

  def index
    @location_menus = @location.location_menus
  end

  def edit
    @location_menu = LocationMenu.find(params[:id])
  end

  def new
    @location_menu = @location.location_menus.new
  end

  def create
    @location_menu = @location.location_menus.new(location_menu_params)

    if @location_menu.save
      redirect_to @location, notice: 'Menu was successfully created.'      
    else
      render action: "new"
    end
  end

  def update
    @location_menu = LocationMenu.find(params[:id])

    if @location_menu.update(location_menu_params)
      redirect_to [@location, @location_menu], notice: 'Menu was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @location_menu.destroy
    redirect_to location_location_menus_url
  end

  private

  def location_menu_params
    params.require(:location_menu).permit(:caption, :location_id, :image)
  end

  def find_location
    @location = Location.friendly.find(params[:location_id])
  end
end
