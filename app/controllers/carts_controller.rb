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
    redirect_to :edit_cart
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
    @cart.line_items.delete_all

    respond_to do |format|
      format.html { redirect_to @cart }
      format.json { head :no_content }
    end
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

  private

    def find_cart
      @cart = current_user.cart
    end

    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_index_url, notice: 'Invalid cart'
    end

end
