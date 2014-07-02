class RealEstateListingImagesController < ApplicationController
  def destroy
    @image = RealEstateListingImage.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
