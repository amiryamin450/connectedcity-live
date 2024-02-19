class EventsController < ApplicationController
  before_action :load_location
  load_resource :location
  # load_and_authorize_resource :event, through: [:location], except: [:show, :edit, :update, :destroy]

  def index
    @location = Location.find_by_slug(params[:location_id])
    @events = @location.events.unscoped.store_event.where(location_id: @location.id)
  end

  def show
    @event = Event.unscoped.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @event }
    end
  end

  def new
    @is_location_normal = @location.hall_id.blank? && @location.councillor_id.blank? && @location.commissioner_id.blank?
    @is_municipality = !@is_location_normal || @location.slug === 'city-of-vancouver'
    @vertical_market = @location.vertical_market_categories.first.vertical_market if @location.vertical_market_categories.size > 0
    if [164, 174].include?(@vertical_market.id)
      names = @vertical_market.id === 164 ? 'Provincial Updates' : 'Federal Updates'
      @categories_news = Category.where(name: names)
    end
    @event = @location.events.new(starts_at: Time.now, ends_at: Time.now + 1.hour, email: current_user.email )
  end

  def edit
    @event = Event.unscoped.find(params[:id])
    @location = @event.location
    @is_location_normal = @location.hall_id.blank? && @location.councillor_id.blank? && @location.commissioner_id.blank?
    @is_municipality = !@is_location_normal || @location.slug === 'city-of-vancouver'
    @vertical_market = @location.vertical_market_categories.first.vertical_market if @location.vertical_market_categories.size > 0
    if [164, 174].include?(@vertical_market.id)
      names = @vertical_market.id === 164 ? 'Provincial Updates' : 'Federal Updates'
      @categories_news = Category.where(name: names)
    end
  end

  def create
    @event = @location.events.new(event_params)
    if @event.save
      redirect_to [@location, @event], notice: 'Event was successfully created.'
    else
      render action: :new
    end
  end

    def update
    @event = Event.unscoped.find(params[:id])
    if @event.update_attributes(event_params)
      redirect_to [@location, @event], notice: 'Event was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @event = Event.unscoped.find(params[:id])
    @event.destroy
    redirect_to location_events_url
  end

  def check_scope
  end

  private

  def event_params
    params.require(:event).permit(:description, :email, :ends_at, :name, :starts_at, :url, :slug, :location_id, :image, :category_id, :latitude, :longitude)
  end

  def load_location
    @location = Location.friendly.find(params[:location_id])
  end
end
