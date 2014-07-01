class DistrictsController < ApplicationController
  def homepage
    set_region
    set_subregion
    set_city
    @district = District.find(params[:district])
    add_crumb @district.name
  end
end