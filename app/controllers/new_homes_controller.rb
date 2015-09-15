class NewHomesController < ApplicationController
  load_resource :new_home_community
  load_and_authorize_resource :new_home, through: [:new_home_community]

  # GET /new_homes
  # GET /new_homes.json
  def index
    @location = @new_home_community.location
    @new_homes = @new_home_community.new_homes
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @new_homes }
    end
  end

  # GET /new_homes/1
  # GET /new_homes/1.json
  def show
    @location = @new_home_community.location
    @vertical_market = @location.vertical_market_categories.first.vertical_market

    add_crumb @district.name, district_guide_path(@district) if @district
    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}"
    add_crumb @location.vertical_market_categories.first.name, "#{@base_path}category/#{@location.vertical_market_categories.first.slug}"
    add_crumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_crumb @new_home_community.name, "/business/#{@location.slug}/new_home_communities/#{@new_home_community.slug}"
    add_crumb @new_home.title

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @new_home }
    end
  end

  # GET /new_homes/new
  # GET /new_homes/new.json
  def new
    @new_home = @new_home_community.new_homes.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @new_home }
    end
  end

  # GET /new_homes/1/edit
  def edit
    @new_home = NewHome.find(params[:id])
  end

  # POST /new_homes
  # POST /new_homes.json
  def create
    @new_home = @new_home_community.new_homes.new(params[:new_home])

    respond_to do |format|
      if @new_home.save
        format.html { redirect_to [@location, @new_home_community, @new_home], notice: 'New home was successfully created.' }
        format.json { render json: @new_home, status: :created, location: @new_home }
      else
        format.html { render action: "new" }
        format.json { render json: @new_home.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /new_homes/1
  # PUT /new_homes/1.json
  def update
    @new_home = NewHome.find(params[:id])

    respond_to do |format|
      if @new_home.update_attributes(params[:new_home])
        format.html { redirect_to [@location, @new_home_community, @new_home], notice: 'New home was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @new_home.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /new_homes/1
  # DELETE /new_homes/1.json
  def destroy
    @new_home = NewHome.find(params[:id])
    @new_home.destroy

    respond_to do |format|
      format.html { redirect_to new_homes_url }
      format.json { head :no_content }
    end
  end

end
