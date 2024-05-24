class CitiesController < ApplicationController
  load_and_authorize_resource except: [:homepage, :status_updates, :events, :media_attachments]
  before_action :redirect_back_home, only: [:show]

  layout "application"

  PER_PAGE = 20
  # GET /cities
  # GET /cities.json
  def index
    @cities = City.all

    respond_to do |format|
      format.html
      format.json { render json: @cities }
    end
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
    @city = City.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @city }
    end
  end

  def homepage
    @city = City.find(5915022)
    @carousel_images = @city.carousel_images
    @status_updates = @city.status_updates.where(statusable_type: 'Location').limit(PER_PAGE).order('created_at DESC')
    @events = @city.events.order(:starts_at).limit(PER_PAGE)
    @media_attachments = @city.media_attachments.order('created_at DESC').limit(PER_PAGE)
    @districts = @city.districts
    add_breadcrumb '<i class="icon-home"></i> Home'.html_safe, @base_path
    add_breadcrumb "#{@city.name} Guide"
  end

  def status_updates
    city = City.find(5915022)
    status_updates = city.status_updates.where(statusable_type: 'Location').where("created_at < ?", params[:from]).limit(PER_PAGE).order('created_at DESC')
    render partial: 'status_updates/market_updates', locals:{ status_updates: status_updates }, layout: false
  end

  def events
    city = City.find(5915022)
    events = city.events.where("starts_at >= ? AND events.id NOT IN (?)", params[:from], params[:last_ids] + [0]).order(:starts_at).limit(PER_PAGE)
    render partial: 'events/events_list', locals:{ events: events }, layout: false
  end

  def media_attachments
    city = City.find(5915022)
    media_attachments = city.media_attachments.where("media_attachments.created_at < ?", params[:from]).order('created_at DESC').limit(PER_PAGE)
    render partial: 'media_attachments/videos_list', locals:{ media_attachments: media_attachments }, layout: false
  end
  # GET /cities/new
  # GET /cities/new.json
  def new
    @city = City.new

    respond_to do |format|
      format.html
      format.json { render json: @city }
    end
  end

  # GET /cities/1/edit
  def edit
    @city = City.find(params[:id])
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render json: @city, status: :created, location: @city }
      else
        format.html { render action: "new" }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cities/1
  # PUT /cities/1.json
  def update
    @city = City.find(params[:id])

    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    @city = City.find(params[:id])
    @city.destroy

    respond_to do |format|
      format.html { redirect_to cities_url }
      format.json { head :no_content }
    end
  end

  def redirect_back_home
    #I have added this redirect to avoid broke code beacuse city model had changed to new model but code did not modified.
    redirect_to root_path
  end

  private

  def city_params
    params.require(:city).permit(:csdname, :id, :csdtype, :slug, :municipality_id, :is_active, :geom)
  end
end
