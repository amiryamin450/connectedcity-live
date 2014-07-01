class LocationImagesController < ApplicationController
  def destroy
    @location_image = LocationImage.find(params[:id])
    @location_image.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
