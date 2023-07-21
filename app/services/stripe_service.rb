class StripeService
  def initialize(location, user=nil)
    @location = location
    @user = user
    @return_url = Rails.application.routes.url_helpers.edit_location_url(@location)
    @location.update_column(:payment_user_id, @user) if @user && @location.payment_user_id.nil?
    @account = stripe_account
  end

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

  def self.checkout(params, cart)
    line_items = params[:line_items].map { |item| line_item_data(item, cart) } || []
    return_url = Rails.application.routes.url_helpers.cart_url(cart)
    cart.list_items = cart.line_items
    total_receive = ((cart.total_price_gross * 100).to_i * (100 - ENV['SERVICE_FEE'].to_f) / 100 + 30).to_i

    Stripe::Checkout::Session.create(
      line_items: line_items,
      success_url: return_url,
      cancel_url: return_url,
      payment_method_types: ['card'],
      mode: 'payment',
      # automatic_tax: { enabled: true },
      billing_address_collection: 'required',
      shipping_address_collection: {
        allowed_countries: ['US', 'CA'],
      },
      payment_intent_data: {
        transfer_data: {
          amount: total_receive,
          destination: params[:line_items].first[:destination_id],
        },
      }
    )
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

  def self.line_item_data(item, cart)
    amount = item[:amount].to_f * 100
    amount += (amount * cart.tax_pst + amount * cart.tax_gst).to_i

    {
      quantity: item[:quantity],
      price_data: {
        product_data: { name: item[:name] },
        unit_amount: amount.to_i,
        currency: 'cad'
      }
    }
  end
end
