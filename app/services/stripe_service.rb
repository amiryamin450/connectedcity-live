class StripeService
  # Initializer
  def initialize(location: nil, user: nil, cart: nil, params: nil)
    if cart && params
      @cart = cart
      @params = params
    else
      @location = location
      @user = user
      @return_url = Rails.application.routes.url_helpers.edit_location_url(@location)
      @location.update_column(:payment_user_id, @user) if @user && @location.payment_user_id.nil?
      @account = stripe_account
    end
  end

  # Actions
  def create_account_link
    @account ||= create_stripe_account
    @location.update_column(:stripe_account_id, @account.id) unless @location.stripe_account_id
    created_account_link(@account)
  end

  def stripe_connect_status
    return nil if @account.nil?

    @account.try(:details_submitted)
  end

  def remove_stripe_account
    begin
      Stripe::Account.delete(@location.stripe_account_id) if @location.stripe_account_id
    rescue => exception
      nil
    end
    @location.update_column(:stripe_account_id, nil)
  end

  def checkout
    return_url = Rails.application.routes.url_helpers.cart_url(@cart)
    @cart.list_items = query_list_items(@params[:location_id])
    line_items = @cart.list_items.map { |item| line_item_data(item) }

    charge = Stripe::Checkout::Session.create(
      line_items: line_items,
      success_url: Rails.application.routes.url_helpers.checkout_successful_cart_url(@cart) + '?session_id={CHECKOUT_SESSION_ID}' + "#{'&location_id=' + @params[:location_id] if @params[:location_id].present? }",
      cancel_url: return_url,
      payment_method_types: ['card'],
      mode: 'payment',
      billing_address_collection: 'required',
      shipping_address_collection: {
        allowed_countries: ['US', 'CA'],
      }
    )
  end

  def checkout_successful
    charge = Stripe::Checkout::Session.retrieve(@params[:session_id])

    if charge.present? && charge.status == 'complete'
      checkout_only_one_shop = @params[:location_id].present?
      merchants = []

      if checkout_only_one_shop
        location = Location.unscoped.friendly.find(@params[:location_id])
        merchants.push(location) if location.present?
      else
        locations = Location.where(id: @cart.line_items.pluck(:location_id).uniq)
        merchants = locations if locations.present?
      end

      merchants.each do |merchant|
        order = Order.create(
          status: :in_progress,
          payment_method: "visa/mc",
          customer: @cart.user,
          seller: merchant,
          shipment_attributes: {
            status: :preparing,
            delivery_method: :pickup_in_store,
            shipping_name: charge.shipping_details.name,
            shipping_address: charge.shipping_details.address.to_json
          }
        )

        if order.persisted?
          line_items = @cart.line_items.where(location_id: merchant.id)
          line_items.update_all(paid: true, order_id: order.id, cart_id: nil)

          recipients = [@cart.user.email, merchant.email, "brian1@yopmail.com", "gtaylor@connectedcity.com"]
          recipients.each do |recipient|
            OrderMailer.order_created(recipient, order, @cart.user).deliver
          end

        else
          raise "Can't create an order with error: #{order.errors.full_messages}!"
        end
      end

      # list_items = query_list_items(@params[:location_id])

      # list_items.group_by(&:location_id).each do |location_id, items|
      #   location = Location.find(location_id)
      #   @cart.list_items = items
      #   merchant_total_receive = (@cart.total_price_gross * 100 * (100 - ENV['SERVICE_FEE'].to_f) / 100 - 30).to_i

      #   Stripe::Transfer.create({
      #     amount: merchant_total_receive,
      #     destination: location.stripe_account_id,
      #     currency: 'cad'
      #   })
      # end
    end

  end

  private

  def stripe_account
    if @location.stripe_account_id
      Stripe::Account.retrieve(@location.stripe_account_id)
    else
      nil
    end
  end

  def create_stripe_account
    Stripe::Account.create({
      type: 'express',
      country: @location.country.country_code,
      email: @user.email,
      business_profile: {
        name: @location.name,
        support_phone: @location.phone,
        support_address: {
          city: @location,
          country: @location.country.country_code,
          line1: @location.address,
          postal_code: @location.postal_code,
          state: @location.province.province_code
        },
      },
      capabilities: {
        card_payments: {requested: true},
        transfers: {requested: true},
      },
    })
  end

  def created_account_link(stripe_account)
    Stripe::AccountLink.create({
      account: stripe_account.id,
      refresh_url: @return_url,
      return_url: @return_url,
      type: 'account_onboarding',
    }).try(:url)
  end

  def query_list_items(location_id=nil)
    if location_id.present?
      location = Location.find_by_slug(location_id)
    end

    condition_location_id = location ? { location_id: location.id } : {}
    @cart.line_items.where(condition_location_id)
  end

  def line_item_data(item)
    amount = item.total_price * 100 / item.quantity
    amount += amount * @cart.tax_pst + amount * @cart.tax_gst

    {
      quantity: item.quantity,
      price_data: {
        product_data: { name: item.product.name },
        unit_amount: amount.to_i,
        currency: 'cad'
      }
    }
  end
end
