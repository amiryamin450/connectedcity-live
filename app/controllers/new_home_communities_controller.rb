class NewHomeCommunitiesController < ApplicationController
  load_resource :location
  load_and_authorize_resource :new_home_community, through: [:location]
  # GET /new_home_communities
  # GET /new_home_communities.json
  def index
    @new_home_communities = @location.new_home_communities
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @new_home_communities }
    end
  end

  # GET /new_home_communities/1
  # GET /new_home_communities/1.json
  def show
    @vertical_market = @location.vertical_market_categories.first.vertical_market


    add_crumb @district.name, district_guide_path(@district) if @district
    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}"
    add_crumb @location.vertical_market_categories.first.name, "#{@base_path}category/#{@location.vertical_market_categories.first.slug}"
    add_crumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_crumb @new_home_community.name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @new_home_community }
    end
  end

  # GET /new_home_communities/new
  # GET /new_home_communities/new.json
  def new
    @new_home_community = @location.new_home_communities.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @new_home_community }
    end
  end

  # GET /new_home_communities/1/edit
  def edit
    @new_home_community = NewHomeCommunity.find(params[:id])
  end

  # POST /new_home_communities
  # POST /new_home_communities.json
  def create
    @new_home_community = @location.new_home_communities.new(params[:new_home_community])

    respond_to do |format|
      if @new_home_community.save
        format.html { redirect_to [@location, @new_home_community], notice: 'New home community was successfully created.' }
        format.json { render json: @new_home_community, status: :created, location: @new_home_community }
      else
        format.html { render action: "new" }
        format.json { render json: @new_home_community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /new_home_communities/1
  # PUT /new_home_communities/1.json
  def update
    @new_home_community = NewHomeCommunity.find(params[:id])

    respond_to do |format|
      if @new_home_community.update_attributes(params[:new_home_community])
        format.html { redirect_to [@location, @new_home_community], notice: 'New home community was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @new_home_community.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /new_home_communities/1
  # DELETE /new_home_communities/1.json
  def destroy
    @new_home_community = NewHomeCommunity.find(params[:id])
    @new_home_community.destroy

    respond_to do |format|
      format.html { redirect_to new_home_communities_url }
      format.json { head :no_content }
    end
  end

end
