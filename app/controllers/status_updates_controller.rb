class StatusUpdatesController < ApplicationController
  before_action :location
  load_resource :location, :business_improvement_area
  load_and_authorize_resource :status_update, through: [:location, :business_improvement_area], except: :index
  before_action :status_update, only: [:show, :edit, :update]
  layout "application_v_2"

  def index
    @status_updates = location.status_updates
  end

  def new
    @status_update = location.status_updates.build
    @status_update.social_profile_ids = location.social_profiles.pluck(:id).map(&:to_s)
  end

  def show
  end

  def edit
  end

  def create
    @status_update = location.status_updates.new(status_update_params)
    if @status_update&.latitude&.abs.present? && @status_update&.longitude&.abs
      @status_update.latitude = @status_update&.latitude&.abs
      @status_update.longitude = -(@status_update&.longitude&.abs)
    end

    is_success = @status_update.save

    respond_to do |format|
      if is_success
        format.html { redirect_to action: :index }
        format.json { render json: { success: is_success } }
      else
        format.html { render :new }
        format.json { render json: { success: is_success, errors: @status_update.errors }, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @status_update.update(status_update_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @status_update = StatusUpdate.find(params[:id])
    @status_update.destroy

    redirect_back fallback_location: location_status_updates_path
  end

  private

  def status_update
    @status_update = StatusUpdate.find_by_id(params[:id])
  end

  def location
    @location ||= Location.unscoped.friendly.find(params[:location_id])
  end

  def status_update_params
    params.require(:status_update).permit(:content, :provider, :district_id, :neighborhood_id, :latitude, :longitude, :city_id, :province_id,
      :vertical_markets, :vertical_market_categories, :image, :social_profile_ids, :category_id)
  end
end
