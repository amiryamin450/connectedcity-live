class ClassifiedCategoriesController < ApplicationController
  load_and_authorize_resource find_by: :slug
  # GET /classified_categories
  # GET /classified_categories.json
  def index
    @classified_categories = ClassifiedCategory.all

    respond_to do |format|
      format.html
      format.json { render json: @classified_categories }
    end
  end

  # GET /classified_categories/1
  # GET /classified_categories/1.json
  def show
    # @classified_category = ClassifiedCategory.find(params[:id])

    add_breadcrumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_breadcrumb 'Classifieds', classifieds_path
    add_breadcrumb @classified_category.name

    respond_to do |format|
      format.html
      format.json { render json: @classified_category }
    end
  end

  # GET /classified_categories/new
  # GET /classified_categories/new.json
  def new
    @classified_category = ClassifiedCategory.new

    respond_to do |format|
      format.html 
      format.json { render json: @classified_category }
    end
  end

  # GET /classified_categories/1/edit
  def edit
    # @classified_category = ClassifiedCategory.find(params[:id])
  end

  # POST /classified_categories
  # POST /classified_categories.json
  def create
    @classified_category = ClassifiedCategory.new(classified_category_params)

    respond_to do |format|
      if @classified_category.save
        format.html { redirect_to @classified_category, notice: 'Classified category was successfully created.' }
        format.json { render json: @classified_category, status: :created, location: @classified_category }
      else
        format.html { render action: "new" }
        format.json { render json: @classified_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /classified_categories/1
  # PUT /classified_categories/1.json
  def update
    # @classified_category = ClassifiedCategory.find(params[:id])

    respond_to do |format|
      if @classified_category.update_attributes(classified_category_params)
        format.html { redirect_to @classified_category, notice: 'Classified category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @classified_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classified_categories/1
  # DELETE /classified_categories/1.json
  def destroy
    # @classified_category = ClassifiedCategory.find(params[:id])
    @classified_category.destroy

    respond_to do |format|
      format.html { redirect_to classified_categories_url }
      format.json { head :no_content }
    end
  end

  private

  def classified_category_params
    params.require(:classified_category).permit(:name, :slug, :heading_color)
  end
end
