# TODO: remove, no longer used
class SubRegionsController < ApplicationController
  def homepage
    set_region
    @sub_region = @region.sub_regions.find(params[:sub_region])
    add_breadcrumb "#{@sub_region.name} Guide"
    @cities = @sub_region.cities    
  end
end
