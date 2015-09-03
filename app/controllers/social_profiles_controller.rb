class SocialProfilesController < ApplicationController
  load_resource :location, instance_name: :owner, class: "Location"
  load_and_authorize_resource :social_profile, through: :owner

  # GET /owner_class/:id/social-profiles
  def index
    add_crumb @owner.name, url_for(@owner)
    add_crumb "Social Profiles"
  end

  def new
    redirect_to case params[:social_network].to_sym
                when :facebook
                  facebook_oauth(polymorphic_url([@owner, :social_profiles], social_network: :facebook, action: :create)).url_for_oauth_code permissions: "manage_pages,publish_pages"
                when :twitter
                  request_token = twitter_consumer.get_request_token oauth_callback: polymorphic_url([@owner, :social_profiles], social_network: :twitter, action: :create)

                  session[:request_token] = request_token.token
                  session[:request_token_secret] = request_token.secret

                  request_token.authorize_url force_login: "true"
                when :instagram
                  Instagram.authorize_url redirect_uri: social_profiles_url(redirect_to: polymorphic_path([@owner, :social_profiles], social_network: :instagram, action: :create))
                else
                  flash[:error] = "You have selected an invalid social network."

                  { action: :index }
                end
  end

  # GET /owner_class/:id/social-profiles/:social_network?code=:access_token
  # GET /owner_class/:id/social-profiles/:social_network?access_token=:access_token&access_token_secret=:access_token_secret
  # PUT /owner_class/:id/social-profiles/:social_network
  def create
    case params[:social_network].to_sym
    when :facebook
      raise StandardError unless params.has_key?(:code)

      if params.has_key?(:uid) && session.has_key?(:access_token)
        api = Koala::Facebook::API.new session[:access_token]
        me = api.get_connections("me", "accounts").select do |account| account["id"] == params[:uid] end.first

        @owner.social_profiles.create social_network: :facebook,
                                      uid: me["id"],
                                      access_token: me["access_token"]

        session.delete :access_token
      else
        unless session.has_key?(:access_token)
          session[:access_token] = facebook_oauth(polymorphic_url([@owner, :social_profiles], social_network: :facebook, action: :create)).get_access_token params[:code]
        end

        api = Koala::Facebook::API.new session[:access_token]
        @accounts = api.get_connections("me", "accounts").map do |account| { name: account["name"], id: account["id"] } end

        if @accounts.any?
          add_crumb @owner.name, url_for(@owner)
          add_crumb "Social Profiles", url_for([@owner, :social_profiles])
          add_crumb "Select a Facebook Page"

          return render "social_profiles/facebook/new"
        else
          flash[:error] = "Your Facebook account does not manage any pages."
        end
      end
    when :twitter
      raise StandardError unless params.has_key?(:oauth_token) && params.has_key?(:oauth_verifier)

      request_token = OAuth::RequestToken.new twitter_consumer, session[:request_token], session[:request_token_secret]
      access_token = request_token.get_access_token oauth_verifier: params[:oauth_verifier]

      client = Twitter::REST::Client.new do |config|
        config.consumer_key = Settings.twitter_consumer_key
        config.consumer_secret = Settings.twitter_consumer_secret
        config.access_token = access_token.token
        config.access_token_secret = access_token.secret
      end

      me = client.user skip_status: true

      @owner.social_profiles.create social_network: :twitter,
                                    uid: me.id,
                                    access_token: access_token.token,
                                    access_token_secret: access_token.secret

      session.delete :request_token
      session.delete :request_token_secret
    when :instagram
      me = Instagram.get_access_token params[:code], redirect_uri: social_profiles_url(redirect_to: polymorphic_path([@owner, :social_profiles], social_network: :instagram, action: :create))

      @owner.social_profiles.create social_network: :instagram,
                                    uid: me.user.id,
                                    access_token: me.access_token
    end rescue flash[:error] = "Something went wrong, please try again."

    redirect_to action: :index
  end

  # DELETE /owner_class/:id/social-profiles/:id
  def destroy
    @social_profile.destroy
    redirect_to action: :index
  end

  private
    def twitter_consumer
      OAuth::Consumer.new Settings.twitter_consumer_key, Settings.twitter_consumer_secret, site: 'https://api.twitter.com',
                                                                                           request_endpoint: 'https://api.twitter.com',
                                                                                           authorize_path: '/oauth/authenticate'
    end

    def facebook_oauth(owner)
      Koala::Facebook::OAuth.new Settings.facebook_app_id, Settings.facebook_app_secret, owner
    end
end
