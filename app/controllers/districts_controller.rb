class DistrictsController < ApplicationController

  load_and_authorize_resource :district, except: :homepage


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
    @district = District.find(params[:district_route])

    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb @district.name
  end
end
