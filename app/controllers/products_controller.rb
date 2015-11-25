class ProductsController < ApplicationController
  load_resource :location
  load_and_authorize_resource :product, through: [:location]

  def index
    @products = @location.products
  end

  def show
    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb @product.location.district.name, district_guide_path(@product.location.district) if @product.location.district
    add_crumb @product.location.neighborhood.name if @product.location.neighborhood
    add_crumb @product.location.broker.name, "#{@base_path}business/#{@product.location.broker.slug}" if @product.location.broker.present?
    add_crumb @product.location.name, "#{@base_path}business/#{@product.slug}"
    add_crumb @product.name
  end

  def new
    @product = @location.products.new
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
    if @product.update_attributes(params[:product])
      redirect_to [@location, @product], notice: 'Product was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to location_products_url
  end

end
