require 'sidekiq/web'

Connectbook::Application.routes.draw do

  


  resources :city_news_articles, path: 'city-news'


  resources :city_news_categories


   mount Sidekiq::Web, at: "/sidekiq"



  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  devise_scope :user do 
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end

  resources :user, controller: 'user' do
    member do
      get :make_admin
      get :remove_admin
      get :favorites
      get :coupons
    end
  end


  match ':status', to: 'errors#show', constraints: { status: /\d{3}/ }, as: :error_page
  resources :businesses, path: 'account'




  resources :cities, :communities, :regions, :provinces, :countries
  resources :location_images, :only => [:destroy]
  resources :favorites, :only => [:create, :destroy]
  resources :vertical_market_categories, :vertical_markets, :neighborhoods
  resources :brands
  resources :classified_categories
  resources :classified_listings, :classified_images
  resources :trade_associations

  resources :employment_categories

  resources :business_improvement_areas, path: 'bia' do 
    resources :carousel_images, defaults: { carouselable: 'business_improvement_area' }
  end

  resources :districts do 
    resources :carousel_images, defaults: { carouselable: 'district' }
  end

  resources :businesses do
    member do
      put 'user_add(/:user_id)', action: :user_add, as: :user_add
    end
  end

  resources :locations, path: 'business', as: :locations do 
    resources :status_updates, path: 'status-updates', only: [:new, :create]
    resources :news_articles, path: 'news'
    resources :blog_entries, path: 'blog'
    resources :products
    resources :services
    resources :events
    resources :automotive_listings
    resources :coupons do 
      member do 
        get :claim
      end
    end
    resources :media_attachments
    resources :real_estate_listings, path: 'listings' do 
      resources :real_estate_listings_images
    end
    resources :employment_listings
    resources :rental_properties do
      resources :rental_units
    end
    
    resources :new_home_communities do
      resources :new_homes
    end

    member do
      get 'claim', action: :claim, as: :claim
      get 'release', action: :release, as: :release
    end

  end


  get ':district_route/guide/:market' => 'vertical_markets#guide'
  get ':district_route/business/:id' => 'locations#show', as: :district_location_path
  get ':district_route/:neighborhood/guide/:market' => 'vertical_markets#guide', as: :district_neighborhood_guide
  get ':district_route/:neighborhood/business/:id' => 'locations#show', as: :district_neighborhood_location
  get 'admin/connected_advertiser' => 'home#connected_advertiser', as: :connected_advertiser

  get 'search' => 'vertical_markets#search'
  get 'search/:market/:sub_market' => 'vertical_markets#search', as: :region_sub_market_search
  get 'guide/:market/:sub_market' => 'vertical_markets#guide', as: :region_sub_market_guide

  get ':district_route/search' => 'vertical_markets#search'
  get ':district_route/search/:market' => 'vertical_markets#search'
  get ':district_route/search/:market/:sub_market' => 'vertical_markets#search'
  get 'search/:market' => 'vertical_markets#search', as: :region_market_search
  get 'guide/:market' => 'vertical_markets#guide', as: :region_market_guide

  get 'employment-opportunities' => 'employment_listings#guide', as: :employment_opportunity
  get 'classifieds' => 'classified_listings#guide', as: :classifieds 
  get ':district_route/category/:id' => 'vertical_market_categories#show'
  get 'category/:id' => 'vertical_market_categories#show'
  get 'city-news-guide' => 'city_news_articles#guide', as: :city_news_guide

  get 'profile' => 'profile#show'
  get 'brands_autocomplete' => 'brands#autocomplete'
  get '/js/autocomplete/users' => 'autocomplete#users', :as => :users_autocomplete

#ActiveAdmin.routes(self)

  root to: 'cities#homepage'
  get '/release/coupon/:id', to: 'user#release_coupon', as: :release_coupon
  get '/redeem/coupon/:id', to: 'coupons#redeem', as: :redeem_coupon
  get ":district_route", to: 'districts#homepage', as: :district_guide

end
