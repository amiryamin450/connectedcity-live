class ClassifiedCategoriesController < ApplicationController
  load_and_authorize_resource
  # GET /classified_categories
  # GET /classified_categories.json
  def index
    @classified_categories = ClassifiedCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @classified_categories }
    end
  end

  # GET /classified_categories/1
  # GET /classified_categories/1.json
  def show
    @classified_category = ClassifiedCategory.find(params[:id])

    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb 'Classifieds', classifieds_path
    add_crumb @classified_category.name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @classified_category }
    end
  end

  # GET /classified_categories/new
  # GET /classified_categories/new.json
  def new
    @classified_category = ClassifiedCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @classified_category }
    end
  end

  # GET /classified_categories/1/edit
  def edit
    @classified_category = ClassifiedCategory.find(params[:id])
  end

  # POST /classified_categories
  # POST /classified_categories.json
  def create
    @classified_category = ClassifiedCategory.new(params[:classified_category])

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
    @classified_category = ClassifiedCategory.find(params[:id])

    respond_to do |format|
      if @classified_category.update_attributes(params[:classified_category])
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
    @classified_category = ClassifiedCategory.find(params[:id])
    @classified_category.destroy

    respond_to do |format|
      format.html { redirect_to classified_categories_url }
      format.json { head :no_content }
    end
  end
end
