class EventsController < ApplicationController
  load_and_authorize_resource :location
  load_and_authorize_resource :event 

  def index
    @events = @location.events 
  end

  def show    
  end

  def new
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