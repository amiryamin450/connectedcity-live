class ProductsController < ApplicationController
  load_resource :location, except: [:deeper_categories, :select_category]
  load_and_authorize_resource :product, through: [:location], except: [:deeper_categories, :select_category, :specific]

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
    @cart = user_signed_in? ? current_user.cart : nil
    respond_to do |format|
      format.html { render layout: "application_v_2"}
      format.json { render json:  @product.product_images.map{|file| file.to_jq_upload }.to_json(include: :product_images)  }
    end
  end

  def new
    # TODO: Require connect to Stripe before add product
    # unless StripeService.new(@location).stripe_connect_status
    #   redirect_to edit_location_path(@location)
    #   flash[:danger] = "Please connect to Stripe before add products"
    # end

    @product = @location.products.new
    @categories = Category.where(parent_id: nil).order(:name)
    if params[:category_id].present? && params[:category_id] != 'all'
      @product.category_id = params[:category_id]
      category = Category.find(params[:category_id])
      is_children = category.parent_id.present?
      if is_children
        @lv2_categories = Category.where(parent_id: category.parent_id).order(:name)
        cate_parent = Category.find(category.parent_id)
        is_still_children = cate_parent.parent_id.present?
        if is_still_children
          @lv3_categories = @lv2_categories
          @lv2_categories = Category.where(parent_id: cate_parent.parent_id).order(:name)
        end
      end
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    product_image_ids_param = params[:product].delete('product_image_ids')
    @product = @location.products.new(params[:product])

    if @product.save
      result = product_images_slide(product_image_ids_param)
      result.each do |p|
        p.product_id = @product.id
        p.save
      end
      redirect_to [@location], notice: 'Product was successfully created.'
    else
      @categories = Category.where(parent_id: nil).order(:name)
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
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
    @lv2_categories = Category.find(params[:id]).children.order(:name)
    @lv = params[:lv].to_i + 1
  end

  def select_category
    @category = Category.find(params[:id])
  end

  def product_images_slide param_ids
    ids = param_ids.split(',').map do |id| id.to_i  end
    ProductImage.where(id: ids)
  end

  def specific
    @category_id = params[:category_id]
    lproducts = @location.products
    category_ids = lproducts.group_by { |a| a.category_id.itself }.keys
    category_ids.delete_at(category_ids.index(0)) if category_ids.include?(0)
    @categories = Category.where(id: category_ids).order(:name)
    if @category_id === 'all'
      @products = lproducts.order('created_at DESC')
    else
      @products = lproducts.where(category_id: @category_id).order('created_at DESC')
    end
  end

end
