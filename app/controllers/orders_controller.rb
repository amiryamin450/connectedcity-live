class OrdersController < ApplicationController
  layout "application_v_2"

  before_action :authenticate_user
  before_action :load_order, except: [:index]

  rescue_from ActiveRecord::RecordNotFound, with: :order_not_found

  def index
    @orders = Order.all
  end

  def show
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "show" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def load_order
      @order ||= Order.find(params[:id])
    end

    def order_not_found
      logger.error "Order with id:#{params[:id]} can't be found!"
      redirect_to orders_url
    end

    def order_params
      params.require(:order).permit(:status)
    end
end
