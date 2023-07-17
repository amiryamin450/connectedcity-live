class StripeService
  def initialize(location, user)
    @location = location
    @user = user
    @return_url = Rails.application.routes.url_helpers.edit_location_url(@location)
    @location.update_column(:payment_user_id, @user) if @location.payment_user_id.nil?
  end

  def create_account_link
    stripe_account = if @location.stripe_account_id
      Stripe::Account.retrieve(@location.stripe_account_id)
    else
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

    if stripe_account
      @location.update_column(:stripe_account_id, stripe_account.id) unless @location.stripe_account_id
      Stripe::AccountLink.create({
        account: stripe_account.id,
        refresh_url: @return_url,
        return_url: @return_url,
        type: 'account_onboarding',
      })
    else
      {}
    end
  end
end
