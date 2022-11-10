module PrismicService
  class << self

    ## Easier initialisation of the Prismic::API object.
    def init_api(access_token)
      access_token ||= self.access_token
      Prismic.api(self.url, access_token)
    end

    def oauth_initiate_url(access_token, oauth_opts)
      access_token ||= self.access_token
      Prismic.oauth_initiate_url(self.url, oauth_opts, access_token)
    end

    def oauth_check_token(access_token, oauth_opts)
      access_token ||= self.access_token
      Prismic.oauth_check_token(self.url, oauth_opts, access_token)
    end

    # The access token in configuration.
    def access_token
      ENV['PRISMIC_TOKEN']
    end

    def cliendt_id
      ENV['PRISMIC_CLIENT_ID']
    end

    def client_secret
      ENV['PRISMIC_CLIENT_SECRET']
    end

    def url
      ENV['PRISMIC_URL']
    end

  end
end
