class ClassifiedImagesController < ApplicationController
  def destroy
    @image = ClassifiedImage.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
