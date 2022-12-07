class LineItemsController < ApplicationController
  before_filter :authenticate_user!
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
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product, params[:quantity])
    @line_item.location_id = product.location_id
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart, notice: 'Line item was successfully created.' }
        format.json { render :show,
        status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item.quantity = params[:quantity]
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
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to @line_item.cart }
      format.json { head :no_content }
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
