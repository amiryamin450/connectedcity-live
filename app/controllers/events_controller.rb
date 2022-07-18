class EventsController < ApplicationController
  load_resource :location
  load_and_authorize_resource :event, through: [:location]

  def index
    @events = @location.events
  end

  def show
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
    @event = Event.find(params[:id])
  end

  def create
    @event = @location.events.new(params[:event])
    if @event.save
      redirect_to [@location, @event], notice: 'Event was successfully created.'
    else
      render action: :new
    end
  end

    def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to [@location, @event], notice: 'Event was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to location_products_url
  end

end
