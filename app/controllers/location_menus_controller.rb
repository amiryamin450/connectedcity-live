class LocationMenusController < ApplicationController
  load_and_authorize_resource
  def destroy
    @location_menu = LocationMenu.find(params[:id])
    @location_menu.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
