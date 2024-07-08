Connectbook::Application.routes.draw do
  resources :home do
    collection do
      get :get_regions
      get :get_municipalities
      get :get_cities
      get :get_districts
      get :get_neighborhoods
      get :get_sub_neighborhood
      get :get_sub_neighborhoods
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: "registrations", confirmations: "confirmations", sessions: "sessions" }

  devise_scope :user do
    get 'business_sign_up', :to => 'devise/registrations#new', as: :business_sign_up
    get '/users/sign_out' => 'devise/sessions#destroy'
    post :verify_two_factor, to: 'sessions#verify_two_factor'
    post :request_reset_2fa_code, to: 'sessions#request_reset_2fa_code'
    get 'reset_2fa_code/:id', to: 'sessions#reset_2fa_code'
  end

  resources :line_items

  resources :carts do
    member do
      post :clear
      get  :checkout_successful
    end

    post :checkout, on: :collection
  end

  resources :orders, only: [:index, :show, :update]

  # Routes that require authentication.
  authenticate :user do
    resources :social_profiles, path: "social-profiles", only: [] do
      collection do
        get "", to: redirect { |_, request| "#{request.params[:redirect_to]}?#{request.params.except(:redirect_to, :social_network).to_query}" }, constraints: ->(request) { request.params[:code] }, as: ""
      end
    end

    resources :classified_images, only: [:destroy]
    resources :classified_listings, except: [:index, :show]
    resources :favorites, only: [:create, :destroy] do
      post :user_follow, on: :collection
    end
    resources :location_images, only: [:destroy]
    resources :product_images, only: [:destroy, :new, :create] do
      collection do
        post :upload_images
      end
    end

    resources :coupons, only: [] do
      member do
        get :claim
      end
    end

    resources :districts, only: [] do
      resources :carousel_images, defaults: { carouselable: 'district' }
    end

    get "business/new", to: "locations#new"

    get "citizen/:id", to: "locations#show_citizen", as: :show_citizen

    get "citizen/:id/edit", to: "locations#edit_citizen", as: :edit_citizen

    #############################################
    resources :locations, path: 'business', as: :locations, only: [:edit, :update] do
      resources :automotive_listings, except: [:show]
      resources :blog_entries, path: 'blog', except: [:show]
      resources :coupons, except: [:show]
      resources :employment_listings, except: [:show]
      resources :events, except: [:show]
      resources :media_attachments, only: [:new, :create, :index, :destroy] do
        collection do
          get :new_youtube_video
        end
      end
      resources :location_menus, except: [:show]
      resources :news_articles, path: 'news', except: [:show]

      resources :new_home_communities, except: [:show] do
        resources :status_updates, only: [] do
          member do
            delete "destroy_status_update", controller: "new_home_communities", as: ''
          end
        end
      end

      resources :rental_properties, except: [:show] do
        resources :status_updates, only: [] do
          member do
            delete "destroy_status_update", controller: "rental_properties", as: ''
          end
        end
      end

      resources :products, except: [:show] do
        collection do
          get 'specific/:category_id' => 'products#specific', as: :specific
        end
      end

      resources :services, except: [:show]
      resources :real_estate_listings, path: 'listings', except: [:show]
      resources :status_updates, path: 'status-updates', only: [:index, :new, :create, :destroy]
      resources :managers, only: [:new, :create, :destroy]
      resources :messages, only: [:new, :create]

      resources :real_estate_listings, path: 'listings', except: [:show] do
        resources :real_estate_listings_images, only: [:destroy]
      end

      member do
        get 'claim', action: :claim, as: :claim
        put 'claim', action: :claim_process
        get 'release', action: :release, as: :release
        get :connected_advertiser, as: :connected_advertiser
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

    resources :locations, path: 'citizen', as: :locations, only: [:edit, :update] do
      resources :media_attachments, only: [:new, :create, :index, :destroy], as: :citizen_media_attachments do
        collection do
          get :new_youtube_video
        end
      end
      resources :blog_entries, path: 'blog', as: :citizen_blog, except: [:show]
      resources :status_updates, path: 'status-updates', only: [:index, :new, :create, :destroy], as: :citizen_status_updates
      resources :products, except: [:show], as: :citizen_products do
        collection do
          get 'specific/:category_id' => 'products#specific', as: :specific
        end
      end
      resources :services, except: [:show], as: :citizen_services
      resources :events, except: [:show], as: :citizen_events
      resources :real_estate_listings, path: 'listings', except: [:show], as: :citizen_listings
    end

    #############################################

    resources :new_home_communities, except: [:show] do
      resources :new_homes, except: [:show]
    end

    resources :user, controller: 'user', only: [] do
      member do
        get :coupons
        get :favorites
        put :update_profile
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
    get 'messenger', to: 'messages#messenger'
    get 'messenger/:recipient', to: 'messages#messenger'
    post 'messenger/send_message', to: 'messages#send_message', as: :send_message
    get 'reload_messages', to: 'messages#reload_messages', as: :reload_messages
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
    resources :districts, except: [:show]

    resources :businesses do
      member do
        put 'user_add(/:user_id)', action: :user_add, as: :user_add
      end
    end

    resources :user, controller: 'user' do
      collection do
        post :bulk_delete
      end

      member do
        get :make_admin
        get :remove_admin
      end
    end

    resources :locations, path: 'business', as: :locations, except: [:show] do
      resources :status_updates, path: 'status-updates'
      resources :new_home_communities, except: [:show] do
        resources :new_homes, except: [:show]
      end
      resources :rental_properties, except: [:show] do
        resources :rental_units, except: [:show]
      end

      collection do
        post :bulk_delete
        get :pending_claims
        get :import
        post "import", action: :do_import
        get :export
        get :get_provinces_by_country
        get :get_cities_by_municipality
        get :get_districts_by_city
        get :get_neighborhoods_by_district
        get :get_sub_neighborhoods_by_neighborhood
        get :get_municipalites_by_province
      end

      member do
        get :approve_claim
        get :reject_claim
        get 'update_status/:status', action: :update_status, as: :update_status
      end
    end

    resources :new_home_communities, except: [:show] do
      resources :new_homes, except: [:show]
    end

  end

  resources :brands, only: [:show]
  resources :business_improvement_areas, path: 'neighbourhoods', only: [:show] do
    member do
      get :status_updates
    end
  end

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

  resources :user, only: :show

  resources :locations, path: 'business', as: :locations, only: [:show] do
    resources :automotive_listings, only: [:show] do
      member do
        delete :delete_main_image
        delete "delete_sub_image/:image_id" => 'automotive_listings#delete_sub_image'
      end
    end
    resources :blog_entries, path: 'blog'
    resources :coupons, only: [:show]
    resources :employment_listings, only: [:show]
    resources :events, only: [:show]
    resources :media_attachments, only: [:show, :index]
    resources :location_menus, only: [:show]
    resources :news_articles, path: 'news', only: [:show]
    resources :products, only: [:show]
    resources :real_estate_listings, path: 'listings', only: [:show]
    resources :services, only: [:show]

    collection do
      get :get_provinces_by_country
      get :get_cities_by_municipality
      get :get_districts_by_city
      get :get_neighborhoods_by_district
      get :get_sub_neighborhoods_by_neighborhood
      get :get_municipalites_by_province
    end

    resources :new_home_communities, only: [:show] do
      resources :new_homes, only: [:show]
    end

    resources :rental_properties, only: [:show] do
      resources :rental_units, only: [:show]
    end

    resources :social_profiles, path: "social-profiles", only: [:show]

    resources :media_attachments do
      get :preview
      collection do
        post :start_archive
        post :start_broadcast
        get 'stop_broadcast/:broadcast_id' => 'media_attachments#stop_broadcast'
        get 'stop_archive/:archive_id' => 'media_attachments#stop_archive'
        get 'pause_archive/:archive_id' => 'media_attachments#pause_archive'
        get 'resume_archive/:archive_id' => 'media_attachments#resume_archive'
        get 'preview/:media_attachment_id' => 'media_attachments#preview'
      end
    end

    get 'connect_stripe'
    get 'disconnect_stripe'
  end

  resources :videos do
    get 'check_video_url' => 'videos#check_video_url'
    get 'mute_video_audio' => 'videos#mute_video_audio'
    post :update_media_attachment
    post :upload_thumbnail
    post :upload_audio
  end

  # Static Pages
  get 'about', controller: 'static_pages'
  get 'terms', controller: 'static_pages'
  get 'privacy', controller: 'static_pages'
  get 'advertise', controller: 'static_pages'
  get 'thankyou', controller: 'static_pages', action: 'shopper_thank_you', as: :shopper_thank_you_path
  get 'businessthankyou', controller: 'static_pages', action: 'business_thank_you', as: :business_thank_you_path

  get 'contact' => 'contacts#new'

  post 'media_attachments/vonage_archive_callback' => 'media_attachments#vonage_archive_callback'
  get 'media_attachments/get_vonage_token' => 'media_attachments#get_vonage_token'
  get 'media_attachments/get_broadcast_token' => 'media_attachments#get_broadcast_token'
  get 'media_attachments/get_livestream_token' => 'media_attachments#get_livestream_token'

  get 'video_calls/get_vonage_token' => 'video_calls#get_vonage_token'
  get 'video_calls/call_request' => 'video_calls#call_request'
  put 'video_calls/set_status_call' => 'video_calls#set_status_call'
  get 'video_calls/get_status_from_session' => 'video_calls#get_status_from_session'
  get 'video_calls/get_status_from_location' => 'video_calls#get_status_from_location'
  put 'video_calls/set_available_call_location' => 'video_calls#set_available_call_location'
  get 'video_calls/get_available_call_location' => 'video_calls#get_available_call_location'

  resources 'contacts', only: [:new, :create]

  get '/metro/:municipality_slug/channel/:market/:sub_market' => 'vertical_markets#guide', as: :municipality_sub_market_guide
  get '/metro/:municipality_slug/channel/:market' => 'vertical_markets#guide', as: :municipality_guide

  get '/:city_slug/:district_slug/:neighborhood_slug/:sub_neighborhood_slug/channel/:market' => 'vertical_markets#guide', as: :city_district_nbh_sub_guide
  get '/:city_slug/:district_slug/:neighborhood_slug/:sub_neighborhood_slug/channel/:market/:sub_market' => 'vertical_markets#guide', as: :city_district_nbh_sub_sub_market_guide

  get '/:city_slug/:district_slug/:neighborhood_slug/channel/:market/:sub_market' => 'vertical_markets#guide', as: :city_district_neighborhood_sub_market_guide
  get '/:city_slug/:district_slug/:neighborhood_slug/channel/:market' => 'vertical_markets#guide', as: :city_district_neighborhood_guide

  get '/:city_slug/:district_route/channel/:market/:sub_market' => 'vertical_markets#guide', as: :city_district_sub_market_guide
  get '/:city_slug/:district_route/channel/:market' => 'vertical_markets#guide', as: :city_district_guide

  get '/:city_slug/channel/:market/:sub_market' => 'vertical_markets#guide', as: :city_sub_market_guide
  get '/:city_slug/channel/:market' => 'vertical_markets#guide', as: :city_guide

  get ':district_route/channel/:market' => 'vertical_markets#guide', as: :top_district_guide
  get '/channel/:market' => 'vertical_markets#guide', as: :region_market_guide
  get 'channel/:market/:sub_market' => 'vertical_markets#guide', as: :region_sub_market_guide

  get ':district_route/business/:id' => 'locations#show', as: :district_location_path
  get ':district_route/:neighborhood/channel/:market' => 'vertical_markets#guide', as: :district_neighborhood_guide
  get ':district_route/:neighborhood_route/news' => 'city_news_articles#guide'
  get ':district_route/:neighborhood/business/:id' => 'locations#show', as: :district_neighborhood_location

  get 'search' => 'vertical_markets#search'
  get 'search/:market' => 'vertical_markets#search', as: :region_market_search
  get '/metro/:municipality_slug/search' => 'vertical_markets#search', as: :municipality_search
  get '/:city_slug/:district_slug/:neighborhood_slug/:sub_neighborhood_slug/search' => 'vertical_markets#search', as: :city_district_nbh_sub_search
  get '/:city_slug/:district_slug/:neighborhood_slug/search' => 'vertical_markets#search', as: :city_district_nbh_search
  get '/:city_slug/:district_slug/search' => 'vertical_markets#search', as: :city_district_search
  get '/:city_slug/search' => 'vertical_markets#search', as: :city_search

  get ':district_route/search/:market' => 'vertical_markets#search'

  get 'employment-opportunities' => 'employment_listings#guide', as: :employment_opportunity
  get 'classifieds' => 'classified_listings#guide', as: :classifieds
  get 'neighbourhoods/:business_improment_area_id/category/:id' => 'vertical_market_categories#show', as: :business_improvement_area_vertical_market_category

  get 'category/auto_makes/:make' => 'vertical_market_categories#show_auto_listing_makers', as: :auto_make_show
  get '/metro/:municipality_slug/category/:id' => 'vertical_market_categories#show', as: :municipality_category_show
  get '/:city_slug/:district_slug/:neighborhood_slug/:sub_neighborhood_slug/category/:id' => 'vertical_market_categories#show', as: :city_district_neighborhood_sub_category_show
  get '/:city_slug/:district_slug/:neighborhood_slug/category/:id' => 'vertical_market_categories#show', as: :city_district_neighborhood_category_show
  get '/:city_slug/:district_slug/category/:id' => 'vertical_market_categories#show', as: :city_district_category_show
  get '/:city_slug/category/:id' => 'vertical_market_categories#show', as: :city_category_show
  get '/category/:id' => 'vertical_market_categories#show', as: :category_show

  resources :city_news_articles  do
    collection do
      get :get_neighborhoods
      get :get_sub_neighborhoods
      get :get_districts
      get :get_route_sub_neighborhoods
      get 'filter_updates' => 'city_news_articles#filter_updates', as: 'filter_updates'
      get 'filter_news_articles' => 'city_news_articles#filter_news_articles', as: 'filter_news_articles'
      get 'filter_media_attachments' => 'city_news_articles#filter_media_attachments', as: 'filter_media_attachments'
      get :filter_events
    end
  end
  get "status_updates" => 'cities#status_updates', as: :status_updates_cities
  get "events" => 'cities#events', as: :events_cities
  get "media_attachments" => 'cities#media_attachments', as: :media_attachments_cities

  root to: 'home#index'

  # I'm hard-coding these Marketing URLs for now...
  # The idea is to have connectedcity.com/kitsilano but having this interferes with the district route.
  get 'arbutus-ridge', to: redirect('/neighbourhoods/arbutus-ridge')
  get 'coal-harbour', to: redirect('/neighbourhoods/coal-harbour')
  get 'downtown-eastside', to: redirect('/neighbourhoods/downtown-eastside')
  get 'downtown-vancouver', to: redirect('/neighbourhoods/downtown-vancouver')
  get 'dunbar-southlands', to: redirect('/neighbourhoods/dunbar-southlands')
  # get 'fairview', to: redirect('/neighbourhoods/fairview')
  get 'gastown', to: redirect('/neighbourhoods/gastown')
  get 'grandview-woodland', to: redirect('/neighbourhoods/grandview-woodland')
  get 'granville-island', to: redirect('/neighbourhoods/granville-island')
  get 'hastings-sunrise', to: redirect('/neighbourhoods/hastings-sunrise')
  get 'kensington-cedar-cottage', to: redirect('/neighbourhoods/kensington-cedar-cottage')
  get 'kerrisdale', to: redirect('/neighbourhoods/kerrisdale')
  get 'killarney', to: redirect('/neighbourhoods/killarney')
  # get 'kitsilano', to: redirect('/neighbourhoods/kitsilano')
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

  get 'kitsilano', to: redirect('/british-columbia/lower-mainland/vancouver-metro/vancouver/vancouver-westside/kitsilano')
  get 'kitsbeach', to: redirect('/british-columbia/lower-mainland/vancouver-metro/vancouver/vancouver-westside/kitsilano/kits-beach')
  get 'kitswest4thave', to: redirect('/british-columbia/lower-mainland/vancouver-metro/vancouver/vancouver-westside/kitsilano/kits-west-4th-avenue')
  get 'kitswestbroadway', to: redirect('/british-columbia/lower-mainland/vancouver-metro/vancouver/vancouver-westside/kitsilano/kits-west-broadway')
  get 'fairview', to: redirect('/british-columbia/lower-mainland/vancouver-metro/vancouver/vancouver-westside/fairview')
  get 'armourydistrict', to: redirect('/british-columbia/lower-mainland/vancouver-metro/vancouver/vancouver-westside/fairview/armoury-district')
  get 'granvilleisland', to: redirect('/british-columbia/lower-mainland/vancouver-metro/vancouver/vancouver-westside/fairview/granville-island')

  get '/vancouver/', to: 'home#city_landing', as: :city_landing

  get '/vancouver/:district_route', to: 'districts#homepage', as: :district_guide

  match ':status', to: 'errors#show', constraints: { status: /\d{3}/ }, as: :error_page, via: :get

  resources :municipalities do
    collection do
      get :get_manicipalities
      get :get_cities
      get :get_districts
      get :get_neighborhoods
      get :get_sub_neighborhoods
    end
  end
  get "/:province_slug/:region_slug/:municipality_slug", to: 'municipalities#metro_page'

  get "/:province_slug/:region_slug/:municipality_slug/:city_slug", to: 'home#city_landing'
  get "/:province_slug/:region_slug/:municipality_slug/:city_slug/:district_route", to: 'districts#homepage'

  get "/:province_slug/:region_slug/:municipality_slug/:city_slug/:district_slug/:neighborhood_slug/", to: 'neighborhoods#neighborhood_page'
  get "/:province_slug/:region_slug/:municipality_slug/:city_slug/:district_slug/:neighborhood_slug/:sub_neighborhood_slug", to: 'neighborhoods#sub_neighborhood_page'

  get 'deeper_categories', to: 'products#deeper_categories'
  post 'select_category', to: 'products#select_category'
end
