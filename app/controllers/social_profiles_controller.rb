require "instagram"

Instagram.configure do |config|
  config.client_id = "2bf1a3f3b3c7433c814532675cdc4e02"
  config.client_secret = "3941d2e0288e4d79abafa131f6dfcc27"
end

class SocialProfilesController < ApplicationController
  # GET /:owner_type/:owner_id/social-profiles
  def index
    @owner = Location.find params[:location_id]
    @social_profiles = @owner.social_profiles

    add_crumb @owner.name, url_for(@owner)
    add_crumb "Social Profiles"
  end

  def new
    owner = Location.find params[:location_id]

    redirect_to case params[:social_network].to_sym
                when :facebook
                  require "koala"

                  oauth = Koala::Facebook::OAuth.new "1644731362434230", "914d1116cc5a6b665ed4f7c1292b4074", polymorphic_url([owner, :social_profiles], social_network: :facebook, action: :create)
                  oauth.url_for_oauth_code permissions: "manage_pages,publish_pages", auth_type: "reauthenticate"
                when :twitter
                  require "oauth"

                  consumer = OAuth::Consumer.new "umyAJ3kCQf8WNWH2wywYKcXOS", "ubK9hstQdIcbX6Ly2gXLAMQLU28dWJX4wwyMoNJ7GvEh0lVRl9", site: 'https://api.twitter.com',
                                                                                                                                    request_endpoint: 'https://api.twitter.com'

                  request_token = consumer.get_request_token oauth_callback: polymorphic_url([owner, :social_profiles], social_network: :twitter, action: :create)

                  session[:request_token] = request_token.token
                  session[:request_token_secret] = request_token.secret

                  request_token.authorize_url force_login: "true"
                when :instagram
                  Instagram.authorize_url redirect_uri: social_profiles_url(redirect_to: polymorphic_path([owner, :social_profiles], social_network: :instagram, action: :create))
                else
                  { action: :index }
                end
  end

  # GET /:owner_type/:owner_id/social-profiles?code=:access_token
  # GET /:owner_type/:owner_id/social-profiles?access_token=:access_token&access_token_secret=:access_token_secret
  # PUT /:owner_type/:owner_id/social-profiles
  def create
    @owner = Location.find params[:location_id]

    case params[:social_network].to_sym
    when :facebook
      if params.has_key?(:code)
        require "koala"

        if params.has_key?(:uid) && session.has_key?(:access_token)
          api = Koala::Facebook::API.new session[:access_token]
          me = api.get_connections("me", "accounts").select do |account| account["id"] == params[:uid] end.first

          @owner.social_profiles.create social_network: :facebook,
                                        uid: me["id"],
                                        access_token: me["access_token"]

          session.delete :access_token
        else
          unless session.has_key?(:access_token)
            oauth = Koala::Facebook::OAuth.new "1644731362434230", "914d1116cc5a6b665ed4f7c1292b4074", polymorphic_url([@owner, :social_profiles], social_network: :facebook, action: :create)
            session[:access_token] = oauth.get_access_token params[:code]
          end

          api = Koala::Facebook::API.new session[:access_token]
          @accounts = api.get_connections("me", "accounts").map do |account| { name: account["name"], id: account["id"] } end

          add_crumb @owner.name, url_for(@owner)
          add_crumb "Social Profiles", url_for([@owner, :social_profiles])
          add_crumb "Select a Facebook Page"

          return render "social_profiles/facebook/new"
        end
      end
    when :twitter
      if params.has_key?(:oauth_token) && params.has_key?(:oauth_verifier)
        require "oauth"
        require "twitter"

        consumer = OAuth::Consumer.new "umyAJ3kCQf8WNWH2wywYKcXOS", "ubK9hstQdIcbX6Ly2gXLAMQLU28dWJX4wwyMoNJ7GvEh0lVRl9", site: 'https://api.twitter.com',
                                                                                                                          request_endpoint: 'https://api.twitter.com',
                                                                                                                          authorize_path: '/oauth/authenticate'

        request_token = OAuth::RequestToken.new consumer, session[:request_token], session[:request_token_secret]
        access_token = request_token.get_access_token oauth_verifier: params[:oauth_verifier]

        client = Twitter::REST::Client.new do |config|
          config.consumer_key = "umyAJ3kCQf8WNWH2wywYKcXOS"
          config.consumer_secret = "ubK9hstQdIcbX6Ly2gXLAMQLU28dWJX4wwyMoNJ7GvEh0lVRl9"
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
      end
    when :instagram
      me = Instagram.get_access_token params[:code], redirect_uri: social_profiles_url(redirect_to: polymorphic_path([@owner, :social_profiles], social_network: :instagram, action: :create))

      @owner.social_profiles.create social_network: :instagram,
                                    uid: me.user.id,
                                    access_token: me.access_token
    end # rescue nil

    redirect_to action: :index
  end

  # DELETE /:owner_type/:owner_id/social-profiles/:id
  def destroy
    social_profile = SocialProfile.find params[:id]
    social_profile.destroy

    redirect_to action: :index
  end
end
