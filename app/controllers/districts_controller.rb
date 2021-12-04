class DistrictsController < ApplicationController

  load_and_authorize_resource :district, except: :homepage

  PER_PAGE = 20

  def index

  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @district = District.new(params[:district])
    if @district.save
      redirect_to districts_path, notice: 'The District was created successfully.'
    else
      render action: 'new'
    end
  end

  def update
    if @district.update_attributes(params[:district])
      redirect_to districts_path, notice: 'The District was updated successfully.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @district.destroy
    redirect_to districts_path, notice: 'The District was deleted successfully.'
  end

  # FIXME Why is this homepage and not show?
  def homepage
    if !request.fullpath.include? "sitemap.xml"
      @district = District.find(params[:district_route])

      @status_updates = @district.status_updates.where(statusable_type: 'Location').limit(PER_PAGE)
      @events = @district.events.order(:starts_at).limit(PER_PAGE)
      @media_attachments = @city.media_attachments.order('created_at DESC').limit(PER_PAGE)
      @news = @city.news_articles.where(newsable_type: "Location").limit(PER_PAGE)
      add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
      add_crumb @district.name
    else
        send_file("#{Rails.root}/public/sitemap.xml", filename: "sitemap.xml", type: "application/xml")
    end
    render layout: "application_v_2"
  end
end
