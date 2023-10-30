class EmploymentCategoriesController < ApplicationController
  load_and_authorize_resource
  # GET /employment_categories
  # GET /employment_categories.json
  def index
    @employment_categories = EmploymentCategory.all

    respond_to do |format|
      format.html
      format.json { render json: @employment_categories }
    end
  end

  # GET /employment_categories/1
  # GET /employment_categories/1.json
  def show
    @employment_category = EmploymentCategory.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @employment_category }
    end
  end

  # GET /employment_categories/new
  # GET /employment_categories/new.json
  def new
    @employment_category = EmploymentCategory.new

    respond_to do |format|
      format.html 
      format.json { render json: @employment_category }
    end
  end

  # GET /employment_categories/1/edit
  def edit
    @employment_category = EmploymentCategory.find(params[:id])
  end

  # POST /employment_categories
  # POST /employment_categories.json
  def create
    @employment_category = EmploymentCategory.new(params[:employment_category])

    respond_to do |format|
      if @employment_category.save
        format.html { redirect_to @employment_category, notice: 'Employment category was successfully created.' }
        format.json { render json: @employment_category, status: :created, location: @employment_category }
      else
        format.html { render action: "new" }
        format.json { render json: @employment_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /employment_categories/1
  # PUT /employment_categories/1.json
  def update
    @employment_category = EmploymentCategory.find(params[:id])

    respond_to do |format|
      if @employment_category.update_attributes(params[:employment_category])
        format.html { redirect_to @employment_category, notice: 'Employment category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @employment_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employment_categories/1
  # DELETE /employment_categories/1.json
  def destroy
    @employment_category = EmploymentCategory.find(params[:id])
    @employment_category.destroy

    respond_to do |format|
      format.html { redirect_to employment_categories_url }
      format.json { head :no_content }
    end
  end

  private

  def employment_category_params
    params.require(:employment_category).permit(:heading_color, :name, :slug)
  end
end
