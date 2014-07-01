class StatusUpdatesController < ApplicationController

  def index
    @location = Location.find(params[:location_id])
    @status_updates = @location.status_updates
  end

end
