class CityNewsCategoriesController < ApplicationController
  load_and_authorize_resource
  # GET /city_news_categories
  # GET /city_news_categories.json
  def index
    @city_news_categories = CityNewsCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @city_news_categories }
    end
  end

  # GET /city_news_categories/1
  # GET /city_news_categories/1.json
  def show
    @city_news_category = CityNewsCategory.find(params[:id])

    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb 'City News', city_news_guide_path
    add_crumb @city_news_category.name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @city_news_category }
    end
  end

  # GET /city_news_categories/new
  # GET /city_news_categories/new.json
  def new
    @city_news_category = CityNewsCategory.new

    respond_to do |format|
      format.html 
      format.json { render json: @city_news_category }
    end
  end

  # GET /city_news_categories/1/edit
  def edit
    @city_news_category = CityNewsCategory.find(params[:id])
  end

  # POST /city_news_categories
  # POST /city_news_categories.json
  def create
    @city_news_category = CityNewsCategory.new(city_news_category_params)

    respond_to do |format|
      if @city_news_category.save
        format.html { redirect_to city_news_categories_url, notice: 'City news category was successfully created.' }
        format.json { render json: @city_news_category, status: :created, location: @city_news_category }
      else
        format.html { render action: "new" }
        format.json { render json: @city_news_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /city_news_categories/1
  # PUT /city_news_categories/1.json
  def update
    @city_news_category = CityNewsCategory.find(params[:id])

    respond_to do |format|
      if @city_news_category.update_attributes(city_news_category_params)
        format.html { redirect_to city_news_categories_url, notice: 'City news category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @city_news_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /city_news_categories/1
  # DELETE /city_news_categories/1.json
  def destroy
    @city_news_category = CityNewsCategory.find(params[:id])
    @city_news_category.destroy

    respond_to do |format|
      format.html { redirect_to city_news_categories_url }
      format.json { head :no_content }
    end
  end

  private

  def city_news_category_params
    params.require(:city_news_category).permit(:name, :slug, :heading_color)
  end
end
