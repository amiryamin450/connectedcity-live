class ProductsController < ApplicationController
  load_resource :location, except: [:deeper_categories, :select_category]
  load_and_authorize_resource :product, through: [:location], except: [:deeper_categories, :select_category]

  def index
    @products = @location.products
  end

  def show
    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb @product.location.district.name, district_guide_path(@product.location.district) if @product.location.district
    add_crumb @product.location.neighborhood.name if @product.location.neighborhood
    add_crumb @product.location.broker.name, "#{@base_path}business/#{@product.location.broker.slug}" if @product.location.broker.present?
    add_crumb @product.location.name, "#{@base_path}business/#{@product.location.slug}"
    add_crumb @product.name

    respond_to do |format|
      format.html { render layout: "application_v_2"}
      format.json { render json:  @product.product_images.map{|file| file.to_jq_upload }.to_json(include: :product_images)  }
    end
  end

  def new
    @product = @location.products.new
    @categories = Category.where(parent_id: nil)
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = @location.products.new(params[:product])
    if @product.save
      redirect_to [@location], notice: 'Product was successfully created.'
    else
      render action: :new
    end
  end

  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to [@location, @product], notice: 'Product was successfully updated.' }
        format.json { render json: { files: [@product.product_images.last.to_jq_upload]}, status: :created, product: @product }
      else

        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end  
  end

  def destroy
    @product.destroy
    redirect_to location_products_url
  end

  def deeper_categories
    @lv2_categories = Category.find(params[:id]).children
    @lv = params[:lv]
  end

  def select_category
    @category = Category.find(params[:id])
  end

end
