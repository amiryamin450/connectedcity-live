class VerticalMarketCategoriesController < ApplicationController
  layout :resolve_layout



  def resolve_layout
    case action_name
    when "show", "search"
      "community_guide"
    else
      "application"
    end
  end
  # GET /admin/vertical_market_categories
  # GET /admin/vertical_market_categories.json
  def index

    @search = VerticalMarketCategory.search(params[:q])

    @vertical_market_categories = @search.result.order(:name).page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vertical_market_categories }
    end
  end

  # GET /admin/vertical_market_categories/1
  # GET /admin/vertical_market_categories/1.json
  def show

    set_region
    set_subregion
    set_city
    set_district

    @vertical_market_category = VerticalMarketCategory.find(params[:id])
    @vertical_market = @vertical_market_category.vertical_market


    add_crumb @vertical_market_category.vertical_market.parent.name, "#{@base_path}guide/#{@vertical_market_category.vertical_market.parent.slug}" unless @vertical_market_category.vertical_market.parent.nil?
    add_crumb @vertical_market_category.vertical_market.name, "#{@base_path}guide/#{@vertical_market_category.vertical_market.slug}"
    add_crumb @vertical_market_category.name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vertical_market_category }
    end
  end

  # GET /admin/vertical_market_categories/new
  # GET /admin/vertical_market_categories/new.json
  def new
    @vertical_market_category = VerticalMarketCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vertical_market_category }
    end
  end

  # GET /admin/vertical_market_categories/1/edit
  def edit
    @vertical_market_category = VerticalMarketCategory.find(params[:id])
  end

  # POST /admin/vertical_market_categories
  # POST /admin/vertical_market_categories.json
  def create
    @vertical_market_category = VerticalMarketCategory.new(params[:vertical_market_category])

    respond_to do |format|
      if @vertical_market_category.save
        format.html { redirect_to @vertical_market_category, notice: 'Vertical market category was successfully created.' }
        format.json { render json: @vertical_market_category, status: :created, location: @vertical_market_category }
      else
        format.html { render action: "new" }
        format.json { render json: @vertical_market_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/vertical_market_categories/1
  # PUT /admin/vertical_market_categories/1.json
  def update
    @vertical_market_category = VerticalMarketCategory.find(params[:id])

    respond_to do |format|
      if @vertical_market_category.update_attributes(params[:vertical_market_category])
        format.html { redirect_to @vertical_market_category, notice: 'Vertical market category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vertical_market_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/vertical_market_categories/1
  # DELETE /admin/vertical_market_categories/1.json
  def destroy
    @vertical_market_category = VerticalMarketCategory.find(params[:id])
    @vertical_market_category.destroy

    respond_to do |format|
      format.html { redirect_to vertical_market_categories_url }
      format.json { head :no_content }
    end
  end
end
