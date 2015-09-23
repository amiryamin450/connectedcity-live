Connectbook::Application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end

  # Routes that require authentication.
  authenticate :user do
    resources :social_profiles, path: "social-profiles", only: [] do
      collection do
        get "", to: redirect { |_, request| "#{request.params[:redirect_to]}?#{request.params.except(:redirect_to, :social_network).to_query}" }, constraints: ->(request) { request.params[:code] }, as: ""
      end
    end

    resources :classified_images, only: [:destroy]
    resources :classified_listings, except: [:index, :show]
    resources :favorites, only: [:create, :destroy]
    resources :location_images, only: [:destroy]

    resources :business_improvement_areas, path: 'bia', only: [] do
      resources :carousel_images, defaults: { carouselable: 'business_improvement_area' }
    end

    resources :coupons, only: [] do
      member do
        get :claim
      end
    end

    resources :districts, only: [] do
      resources :carousel_images, defaults: { carouselable: 'district' }
    end

    resources :locations, path: 'business', as: :locations, only: [:edit, :update] do
      resources :automotive_listings, except: [:show]
      resources :blog_entries, path: 'blog', except: [:show]
      resources :coupons, except: [:show]
      resources :employment_listings, except: [:show]
      resources :events, except: [:show]
      resources :media_attachments, only: [:new, :create]
      resources :news_articles, path: 'news', except: [:show]
      resources :new_home_communities
      resources :products, except: [:show]
      resources :services, except: [:show]
      resources :real_estate_listings, path: 'listings', except: [:show]
      resources :status_updates, path: 'status-updates', only: [:index, :new, :create, :destroy]
      resources :managers, only: [:new, :create, :destroy]

      resources :real_estate_listings, path: 'listings', except: [:show] do
        resources :real_estate_listings_images, only: [:destroy]
      end

      member do
        get 'claim', action: :claim, as: :claim
        get 'release', action: :release, as: :release
        get :connected_advertiser
      end

      resources :social_profiles, path: "social-profiles", only: [:index, :destroy] do
        new do
          get ":social_network" => :new, as: ""
        end

        collection do
          get ":social_network" => :create, constraints: ->(request) { request.params[:code] }, as: :create
          get ":social_network" => :create, constraints: ->(request) { request.params[:oauth_token] && request.params[:oauth_verifier] }
        end
      end
    end

    resources :new_home_communities, except: [:show] do
      resources :new_homes, except: [:show]
    end

    resources :user, controller: 'user', only: [] do
      member do
        get :coupons
        get :favorites
      end
    end

    get 'brands_autocomplete' => 'brands#autocomplete'
    get 'profile' => 'profile#show'
    get 'redeem/coupon/:id', to: 'coupons#redeem', as: :redeem_coupon
    get 'release/coupon/:id', to: 'user#release_coupon', as: :release_coupon

    # This isn't being called anywhere and requires users to be logged in.
    # ^FD 2015-08-14
    # get 'js/autocomplete/users' => 'autocomplete#users', as: :users_autocomplete
  end

  # Routes that require an authenticated administrator.
  authenticated :user, lambda { |u| u.has_role? :admin } do
    require 'sidekiq/web'
    mount Sidekiq::Web, at: '/sidekiq'

    get 'neighborhoods/list', controller: :neighborhoods, action: :list

    resources :brands, except: [:show]
    resources :businesses, path: 'account'
    resources :cities
    resources :city_news_articles, path: 'city-news', except: [:show]
    resources :city_news_categories, except: [:show]
    resources :classified_categories, except: [:show]
    resources :communities
    resources :countries
    resources :employment_categories, except: [:show]
    resources :neighborhoods
    resources :provinces
    resources :regions
    resources :trade_associations, except: [:show]
    resources :vertical_market_categories
    resources :vertical_markets
    resources :business_improvement_areas, path: 'bia', except: [:show]
    resources :districts, except: [:show]

    resources :businesses do
      member do
        put 'user_add(/:user_id)', action: :user_add, as: :user_add
      end
    end

    resources :user, controller: 'user' do
      member do
        get :make_admin
        get :remove_admin
      end
    end

    resources :locations, path: 'business', as: :locations, except: [:show] do
      resources :status_updates, path: 'status-updates', except: [:index, :new, :create]
      resources :new_home_communities
      collection do
        get :pending_claims
      end
      member do
        get :approve_claim
        get :reject_claim
      end
    end

    resources :new_home_communities, except: [:show] do
      resources :new_homes, except: [:show]
    end

  end

  # resources :city_news_articles, path: 'news', only: [:guide] do
  #   member do
  #     get 'guide', action: :guide
  #   end
  # end

  # Unauthenticated routes

  resources :brands, only: [:show]
  resources :business_improvement_areas, path: 'bia', only: [:show]
  resources :city_news_articles, path: 'city-news', only: [:show]
  resources :city_news_categories, only: [:show]
  resources :classified_categories, only: [:show]
  resources :classified_listings, only: [:index, :show]

  resources :districts, only: [] do
    get 'news', controller: :city_news_articles, action: :guide
  end

  resources :employment_categories, only: [:show]
  resources :trade_associations, only: [:show]

  resources :cities, path: 'city', only: [] do
    resources :city_news_articles, path: 'news', only: [:show, :index]
  end

  resources :locations, path: 'business', as: :locations, only: [:show] do
    resources :automotive_listings, only: [:show]
    resources :blog_entries, path: 'blog', only: [:show]
    resources :coupons, only: [:show]
    resources :employment_listings, only: [:show]
    resources :events, only: [:show]
    resources :media_attachments, only: [:show]
    resources :news_articles, path: 'news', only: [:show]
    resources :products, only: [:show]
    resources :real_estate_listings, path: 'listings', only: [:show]
    resources :services, only: [:show]

    resources :new_home_communities, only: [:show] do
      resources :new_homes, only: [:show]
    end

    resources :rental_properties, only: [:show] do
      resources :rental_units, only: [:show]
    end

    resources :social_profiles, path: "social-profiles", only: [:show]
  end

  # get '/districts/:district_id/news' => action: :guide

  # These actions don't expect a sub_market parameters so I removed them for
  # now. ^FD 2015-08-14
  # get 'search/:market/:sub_market' => 'vertical_markets#search', as: :region_sub_market_search
  # get 'guide/:market/:sub_market' => 'vertical_markets#guide', as: :region_sub_market_guide
  # get ':district_route/search/:market/:sub_market' => 'vertical_markets#search'
  get ':district_route/guide/:market' => 'vertical_markets#guide'
  get 'guide/:market' => 'vertical_markets#guide', as: :region_market_guide

  get ':district_route/business/:id' => 'locations#show', as: :district_location_path
  get ':district_route/:neighborhood/guide/:market' => 'vertical_markets#guide', as: :district_neighborhood_guide
  get ':district_route/:neighborhood_route/news' => 'city_news_articles#guide'
  get ':district_route/news' => 'city_news_articles#guide'
  get ':district_route/:neighborhood/business/:id' => 'locations#show', as: :district_neighborhood_location

  get 'search' => 'vertical_markets#search'
  get 'search/:market' => 'vertical_markets#search', as: :region_market_search
  get ':district_route/search' => 'vertical_markets#search'
  get ':district_route/search/:market' => 'vertical_markets#search'

  get 'employment-opportunities' => 'employment_listings#guide', as: :employment_opportunity
  get 'classifieds' => 'classified_listings#guide', as: :classifieds
  get ':district_route/category/:id' => 'vertical_market_categories#show'
  get 'category/:id' => 'vertical_market_categories#show'
  get 'news' => 'city_news_articles#guide', as: :city_news_guide

  root to: 'cities#homepage'

  get ':district_route', to: 'districts#homepage', as: :district_guide
  match ':status', to: 'errors#show', constraints: { status: /\d{3}/ }, as: :error_page
end
