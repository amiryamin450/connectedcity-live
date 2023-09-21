class StatusUpdatesController < ApplicationController
  before_filter :location
  load_resource :location, :business_improvement_area
  load_and_authorize_resource :status_update, through: [:location, :business_improvement_area], except: :index

  def index
    @status_updates = location.status_updates
  end

  def new
    @status_update = location.status_updates.build
    @status_update.social_profile_ids = location.social_profiles.pluck(:id).map(&:to_s)
  end

  def create
    @status_update = location.status_updates.build params[:status_update]
    @status_update.latitude = @status_update.latitude.abs
    @status_update.longitude = -(@status_update.longitude.abs)

    respond_to do |format|
      format.json {
        if @status_update.save
          render json: {success: true}
        else
          render json: {success: false, errors: @status_update.errors}, status: :unprocessable_entity
        end
      }
      format.html {
        if !@status_update.save
          render :new
        else
          redirect_to action: :index
        end
      }
    end
  end

  def destroy
    @status_update = StatusUpdate.find(params[:id])
    @status_update.destroy

    redirect_to :back
  end

  private

  def location
    @location ||= Location.unscoped.find(params[:location_id])
  end

end
