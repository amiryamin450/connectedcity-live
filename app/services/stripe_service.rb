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
end
