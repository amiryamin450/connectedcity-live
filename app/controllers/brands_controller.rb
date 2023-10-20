class BrandsController < ApplicationController
  load_and_authorize_resource except: [:autocomplete]
  # GET /brands
  # GET /brands.json
  def index
    @search = Brand.search(params[:q])
    @brands = @search.result.order(:name).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @brands.where("name like ?", "%#{params[:q]}%")  }
    end
  end

  def autocomplete
    @brands = Brand
    respond_to do |format|
      format.json { render json: @brands.where("name like ?", "%#{params[:q]}%")  }
    end
  end

  # GET /brands/1
  # GET /brands/1.json
  def show
    @brand = Brand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @brand }
    end
  end

  # GET /brands/new
  # GET /brands/new.json
  def new
    @brand = Brand.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @brand }
    end
  end

  # GET /brands/1/edit
  def edit
    @brand = Brand.find(params[:id])
  end

  # POST /brands
  # POST /brands.json
  def create
    @brand = Brand.new(brand_params)

    respond_to do |format|
      if @brand.save
        format.html { redirect_to @brand, notice: 'Brand was successfully created.' }
        format.json { render json: @brand, status: :created, location: @brand }
      else
        format.html { render action: "new" }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /brands/1
  # PUT /brands/1.json
  def update
    @brand = Brand.find(params[:id])

    respond_to do |format|
      if @brand.update_attributes(brand_params)
        format.html { redirect_to @brand, notice: 'Brand was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.json
  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy

    respond_to do |format|
      format.html { redirect_to brands_url }
      format.json { head :no_content }
    end
  end

  private

  def brand_params
    params.require(:brand).permit(:description, :name, :slug, :logo, :website_url, :status_updates_attributes, :home_page_image)
  end
end
