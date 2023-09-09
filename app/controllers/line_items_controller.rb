class LineItemsController < ApplicationController
  before_filter :authenticate_user
  before_filter :find_cart, except: [:new, :create]
  before_filter :find_line_item, except: [:new, :create, :index]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = @cart.line_items
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @product = Product.find(params[:product_id])
    @line_item = @cart.add_product(@product, params[:quantity])
    @line_item.location_id = @product.location_id
    respond_to do |format|
      if @line_item.save
        format.json { render json: @product }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    qty_product = @line_item.product.quantity
    qty_line_item = @line_item.quantity
    qty_param = params[:quantity]
    @line_item.quantity = qty_param > qty_product ? qty_product : qty_param

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render json: {
          line_item: @line_item,
          product: @line_item.product,
          total_net: @cart.total_price_net,
          tax_pst: @cart.tax_pst_price,
          tax_gst: @cart.tax_gst_price,
          total_gross: @cart.total_price_gross,
          total_quantity: @cart.total_quantity
        }}
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    if params[:id].present?
      location_id = @line_item.location_id
      @line_item.destroy
      if params[:back].present? && params[:back].include?('slug=back') && location_id.present?
        @back_url = params[:back]
        list_items = @cart.line_items.where(location_id: location_id)
        @is_empty = list_items.empty?
        if @is_empty
          list_items = @cart.line_items
          @back_url = session[:return_to]
        end
        # return
      else
        @back_url = session[:return_to]
        @cart.reload
        list_items = @cart.line_items
        @is_empty = list_items.empty?
      end
      @cart.list_items = list_items
      results = list_items.group_by { |item| item.location_id.itself }.values
      @line_items = results.map do |line_item|
        line_item.map do |item|
          {
            line_item: item,
            product: item.product,
            total_price: item.total_price,
            location: item.location,
            location_name: item.location_name,
            location_slug: item.location_slug,
            name_slug: item.name_slug,
          }
        end
      end
    end
    if @is_empty
      render 'carts/show.js.erb' , :formats => [:json], :handlers => [:erb]
    else
      render 'destroy.js.erb', :formats => [:json], :handlers => [:erb]
    end
  end

  private

  def find_cart
    @cart = current_user.cart
  end

  def find_line_item
    @line_item = @cart.line_items.find(params[:id])
  end

end
