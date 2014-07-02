class NeighborhoodsController < ApplicationController
  load_and_authorize_resource :neighborhood 

  def index
    @q = Neighborhood.search(params[:q])
    @neighborhoods = @q.result(distinct: true)

  end

  def show
  end

  def edit
    @districts = @neighborhood.city.districts
  end

  def update
    if @neighborhood.update_attributes(params[:neighborhood])
      redirect_to neighborhoods_path, notice: 'The Neighborhood was updated successfully.'
    else
      render action: 'edit'
    end
  end

end