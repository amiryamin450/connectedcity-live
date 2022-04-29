Connectbook::Application.routes.draw do

  resources :home do
    collection do
      get :city_landing
    end
  end

  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: "registrations"}

  devise_for :users do
    get 'business_sign_up', :to => 'devise/registrations#new', as: :business_sign_up
  end

  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end

  resources :line_items
  resources :carts do
    member do
      post :clear
    end
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
    resources :product_images, only: [:destroy]

    resources :business_improvement_areas, path: 'neighbourhoods', except: [:show] do
      resources :messages, only: [:new, :create]
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
      resources :media_attachments, only: [:new, :create, :index, :destroy]
      resources :location_menus, except: [:show]
      resources :news_articles, path: 'news', except: [:show]
      resources :new_home_communities, except: [:show] do
        resources :status_updates, only: [] do
          member do
            delete "destroy_status_update", to: "new_home_communities#destroy_status_update", as: "", path: ""
          end
        end
      end
      resources :rental_properties, except: [:show] do
        resources :status_updates, only: [] do
          member do
            delete "destroy_status_update", to: "rental_properties#destroy_status_update", as: "", path: ""
          end
        end
      end
      resources :products, except: [:show]
      resources :services, except: [:show]
      resources :real_estate_listings, path: 'listings', except: [:show]
      resources :status_updates, path: 'status-updates', only: [:index, :new, :create, :destroy]
      resources :managers, only: [:new, :create, :destroy]
      resources :messages, only: [:new, :create]

      resources :real_estate_listings, path: 'listings', except: [:show] do
        resources :real_estate_listings_images, only: [:destroy]
      end

      member do
        with_options constraints: ->(request) { Location.find(request.params[:id]).user_ids.empty? } do
          get 'claim', action: :claim, as: :claim
          put 'claim', action: :claim_process
        end
        get 'release', action: :release, as: :release
        get :connected_advertiser, as: :connected_advertiser
      end

      resources :social_profiles, path: "social-profiles", only: [:index, :destroy] do
        # eg. social_profiles/new/action
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

    resources :messages, only: [:index, :create, :destroy] do
      collection do
        get ":folder" => :index, constraints: { folder: /sent|trash/ }
      end
    end
    resources :messages, as: :mailboxer_conversations, only: [:show]

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
    resources :vertical_market_categories, except: [:show]
    resources :vertical_markets
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
      resources :new_home_communities, except: [:show] do
        resources :new_homes, except: [:show]
      end
      resources :rental_properties, except: [:show] do
        resources :rental_units, except: [:show]
      end

      # eg. business/action
      collection do
        get :pending_claims
        get :import
        post "import", action: :do_import
        get :export
      end
      # eg. business/:id/action
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
  resources :business_improvement_areas, path: 'neighbourhoods', only: [:show] do
    member do
      get :status_updates
    end
  end
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
    resources :carousel_images, defaults: { carouselable: 'city' }
    resources :city_news_articles, path: 'news', only: [:show, :index]
  end

  resources :locations, path: 'business', as: :locations, only: [:show] do
    resources :automotive_listings, only: [:show]
    resources :blog_entries, path: 'blog', only: [:show]
    resources :coupons, only: [:show]
    resources :employment_listings, only: [:show]
    resources :events, only: [:show]
    resources :media_attachments, only: [:show, :index]
    resources :location_menus, only: [:show]
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

    resources :media_attachments do
      collection do
        post :start_archive
        get 'stop_archive/:archive_id' => 'media_attachments#stop_archive'
        get 'check_video_url/:video_id' => 'media_attachments#check_video_url'
        get 'preview/:media_attachment_id' => 'media_attachments#preview'
      end
    end
  end
  resources :videos do
    post :upload_thumbnail
  end

  #Static Pages
  get 'about' => 'StaticPages#about'
  get 'terms' => 'StaticPages#terms'
  get 'privacy' => 'StaticPages#privacy'
  get 'advertise' => 'StaticPages#advertise'
  get 'thankyou' => 'StaticPages#shopper_thank_you', as: :shopper_thank_you_path
  get 'businessthankyou' => 'StaticPages#business_thank_you', as: :business_thank_you_path
  get 'contact' => 'contacts#new'

  post 'media_attachments/vonage_archive_callback' => 'media_attachments#vonage_archive_callback'
  get 'media_attachments/get_vonage_token' => 'media_attachments#get_vonage_token'

  resources 'contacts', only: [:new, :create]

  # get '/districts/:district_id/news' => action: :guide

  # These actions don't expect a sub_market parameters so I removed them for
  # now. ^FD 2015-08-14
  # get 'search/:market/:sub_market' => 'vertical_markets#search', as: :region_sub_market_search
  # get 'guide/:market/:sub_market' => 'vertical_markets#guide', as: :region_sub_market_guide
  # get ':district_route/search/:market/:sub_market' => 'vertical_markets#search'
  get ':district_route/guide/:market' => 'vertical_markets#guide', as: :top_district_guide
  get 'guide/:market' => 'vertical_markets#guide', as: :region_market_guide

  get ':district_route/business/:id' => 'locations#show', as: :district_location_path
  get ':district_route/:neighborhood/guide/:market' => 'vertical_markets#guide', as: :district_neighborhood_guide
  get ':district_route/:neighborhood_route/news' => 'city_news_articles#guide'
  get ':district_route/news' => 'city_news_articles#guide'
  get ':district_route/:neighborhood/business/:id' => 'locations#show', as: :district_neighborhood_location

  get 'search' => 'vertical_markets#search'
  get 'search/:market' => 'vertical_markets#search', as: :region_market_search
  get ':district_route/:neighborhood/search' => 'vertical_markets#search'
  get ':district_route/:neighborhood/search/:market' => 'vertical_markets#search'
  get ':district_route/search' => 'vertical_markets#search'
  get ':district_route/search/:market' => 'vertical_markets#search'

  get 'employment-opportunities' => 'employment_listings#guide', as: :employment_opportunity
  get 'classifieds' => 'classified_listings#guide', as: :classifieds
  get 'neighbourhoods/:business_improment_area_id/category/:id' => 'vertical_market_categories#show', as: :business_improvement_area_vertical_market_category
  get ':district_route/:neighborhood/category/:id' => 'vertical_market_categories#show'
  get ':district_route/category/:id' => 'vertical_market_categories#show'
  get 'category/auto_makes/:make' => 'vertical_market_categories#show_auto_listing_makers', as: :auto_make_show
  get 'category/:id' => 'vertical_market_categories#show', as: :category_show
  get 'news' => 'city_news_articles#guide', as: :city_news_guide
  get "status_updates" => 'cities#status_updates', as: :status_updates_cities
  get "events" => 'cities#events', as: :events_cities
  get "media_attachments" => 'cities#media_attachments', as: :media_attachments_cities

  root to: 'home#index'

  #I'm hard-coding these Marketing URLs for now...
  #The idea is to have connectedcity.com/kitsilano but having this interferes with the district route.
  get 'arbutus-ridge', to: redirect('/neighbourhoods/arbutus-ridge')
  get 'coal-harbour', to: redirect('/neighbourhoods/coal-harbour')
  get 'downtown-eastside', to: redirect('/neighbourhoods/downtown-eastside')
  get 'downtown-vancouver', to: redirect('/neighbourhoods/downtown-vancouver')
  get 'dunbar-southlands', to: redirect('/neighbourhoods/dunbar-southlands')
  get 'fairview', to: redirect('/neighbourhoods/fairview')
  get 'gastown', to: redirect('/neighbourhoods/gastown')
  get 'grandview-woodland', to: redirect('/neighbourhoods/grandview-woodland')
  get 'granville-island', to: redirect('/neighbourhoods/granville-island')
  get 'hastings-sunrise', to: redirect('/neighbourhoods/hastings-sunrise')
  get 'kensington-cedar-cottage', to: redirect('/neighbourhoods/kensington-cedar-cottage')
  get 'kerrisdale', to: redirect('/neighbourhoods/kerrisdale')
  get 'killarney', to: redirect('/neighbourhoods/killarney')
  get 'kitsilano', to: redirect('/neighbourhoods/kitsilano')
  get 'marpole', to: redirect('/neighbourhoods/marpole')
  get 'mount-pleasant', to: redirect('/neighbourhoods/mount-pleasant')
  get 'oakridge', to: redirect('/neighbourhoods/oakridge')
  get 'point-grey', to: redirect('/neighbourhoods/point-grey')
  get 'renfrew-collingwood', to: redirect('/neighbourhoods/renfrew-collingwood')
  get 'riley-park', to: redirect('/neighbourhoods/riley-park-little-mtn')
  get 'shaughnessy', to: redirect('/neighbourhoods/shaughnessy')
  get 'south-cambie', to: redirect('/neighbourhoods/south-cambie')
  get 'strathcona', to: redirect('/neighbourhoods/strathcona')
  get 'sunset', to: redirect('/neighbourhoods/sunset--2')
  get 'ubc', to: redirect('/neighbourhoods/ubc')
  get 'victoria-fraserview', to: redirect('/neighbourhoods/victoria-fraserview')
  get 'west-end', to: redirect('/neighbourhoods/west-end')
  get 'yaletown', to: redirect('/neighbourhoods/yaletown')

  #End Marketing URLs

  get '/vancouver/', to: 'home#city_landing', as: :city_landing
  # get ':district_route', to: 'districts#homepage', as: :district_guide
  get '/vancouver/:district_route', to: 'districts#homepage', as: :district_guide
  resources :business_improvement_areas, path: '/vancouver/:district_route/neighbourhoods', only: [:show] do
    member do
      get :status_updates
    end
  end


  match ':status', to: 'errors#show', constraints: { status: /\d{3}/ }, as: :error_page
end
