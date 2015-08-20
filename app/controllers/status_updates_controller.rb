class StatusUpdatesController < ApplicationController

  def index
    @status_updates = location.status_updates
  end

  def new
    @status_update = location.status_updates.build
  end

  def create
    @status_update = location.status_updates.build params[:status_update]
    if @status_update.save
      render json: {success: true}
    else
      render json: {success: false, errors: @status_update.errors}, status: :unprocessable_entity
    end
  end

  private 
  def location
    @location ||= Location.find(params[:location_id])
  end

end
