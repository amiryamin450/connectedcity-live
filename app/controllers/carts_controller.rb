class CartsController < ApplicationController
  layout "application_v_2"

  before_filter :authenticate_user!
  before_filter :find_cart, except: [:new, :create]

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  # GET /carts
  # GET /carts.json
  def index
    redirect_to @cart, notice: 'Cart was successfully cleared.'
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
    location_id = nil
    if params[:slug].present?
      location = Location.find_by_slug(params[:slug])
      location_id = location&.id
    end
    if location_id.present? || (params[:slug].present? && params[:slug] == 'back')
      if location_id.present?
        @back_url = "/carts/#{@cart.id}?slug=back"
        list_items = @cart.line_items.where(location_id: location_id)
        @cart.list_items = list_items
        results = list_items.group_by { |item| item.location_id.itself }.values
      else
        @back_url = session[:return_to]
        list_items = @cart.line_items
        @cart.list_items = list_items
        results = list_items.group_by { |item| item.location_id.itself }.values
      end
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
      render 'show.js.erb' , :formats => [:json], :handlers => [:erb]
    else
      @back_url = URI(request.referer || '').path
      session[:return_to] = URI(request.referer || '').path
      list_items = @cart.line_items
      @cart.list_items = list_items
      results = @cart.line_items.group_by { |item| item.location_id.itself }.values
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

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @line_items }
      end
    end
  end

  # GET /carts/new
  # GET /carts/new.json
  def new
    @cart = Cart.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cart }
    end
  end

  # GET /carts/1/edit
  def edit
    @back_url = URI(request.referer || '').path
    @line_items = @cart.line_items.group_by { |item| item.location_id.itself }.values
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(params[:cart])

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render json: @cart, status: :created, location: @cart }
      else
        format.html { render action: "new" }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /carts/1
  # PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update_attributes(params[:cart])
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def clear
    if params[:location_id].present?
      @back_url = session[:return_to]
      items = @cart.line_items.where(location_id: params[:location_id])
      items.destroy_all
      list_items = @cart.line_items
      @cart.list_items = list_items
      results = list_items.group_by { |item| item.location_id.itself }.values
    else
      @cart.line_items.delete_all
      @cart.list_items = []
      results = []
    end
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
      render 'clear.js.erb'
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy

    respond_to do |format|
      format.html { redirect_to carts_url }
      format.json { head :no_content }
    end
  end

  def checkout
    checkout_session = StripeService.new(cart: @cart, params: params).checkout
  
    redirect_to checkout_session.url
  end

  def checkout_successful
    StripeService.new(cart: @cart, params: params).checkout_successful
  
    redirect_to cart_url(@cart)
  end

  private

    def find_cart
      @cart = current_user.cart
    end

    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_index_url, notice: 'Invalid cart'
    end

end
