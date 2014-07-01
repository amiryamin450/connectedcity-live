require 'sidekiq/web'

Connectbook::Application.routes.draw do


  mount Sidekiq::Web, at: "/sidekiq"



  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}


  resources :brands

  # match 'guide/:country/:province/:region/:community/:market/:submarket' => 'guide#community', :defaults => {:market => 'money'}, :as => :guide_show_community, :via => :get
  # match 'guide/:country/:province/:region/:market' => 'guide#region', :defaults => {:market => 'money'}, :as => :guide_show_region, :via => :get
  # match 'guide/:country/:province/:market' => 'guide#province', :defaults => {:market => 'money'}, :as => :guide_show_province, :via => :get
  # match 'guide/:country/:market' => 'guide#country', :defaults => {:market => 'money'}, :as => :guide_show_country, :via => :get
  # match 'guide' => 'guide#index', :as => :guide_index, :via => :get



  resources :businesses, path: 'account'

  resources :cities, :communities, :regions, :provinces, :countries, :users
  resources :location_images, :only => [:destroy]
  resources :favorites, :only => [:create, :destroy]
  resources :vertical_market_categories, :vertical_markets

  resources :businesses do
    member do
      put 'user_add(/:user_id)', action: :user_add, as: :user_add
    end
  end

  resources :locations, path: 'business', as: :locations do 
    resources :status_updates
    resources :news_articles, path: 'news'
    resources :blog_entries, path: 'blog'
    resources :products
    resources :services
    resources :events
    resources :real_estate_listings, path: 'listings'
  end






  match '', to: 'regions#homepage', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www'}
  match 'region/:sub_region/:city/:district/locations/:id' => 'locations#show', as: :district_location
  match 'region/:sub_region/:city/locations/:id' => 'locations#show', as: :city_location
  match 'region/:sub_region/locations/:id' => 'locations#show', as: :sub_region_location

  match 'region/:sub_region/:city/:district/category/:id' => 'vertical_market_categories#show'
  match 'region/:sub_region/:city/category/:id' => 'vertical_market_categories#show'
  match 'region/:sub_region/category/:id' => 'vertical_market_categories#show'

  match 'region/:sub_region/:city/:district/search/:market/:submarket' => 'vertical_markets#search', as: :district_sub_market_search
  match 'region/:sub_region/:city/:district/guide/:market/:submarket' => 'vertical_markets#guide', as: :district_sub_market_guide

  match 'region/:sub_region/:city/:district/search/:market' => 'vertical_markets#search', as: :district_market_search
  match 'region/:sub_region/:city/:district/guide/:market' => 'vertical_markets#guide', as: :district_market_guide

  match 'region/:sub_region/:city/search/:market/:submarket' => 'vertical_markets#search', as: :city_sub_market_search
  match 'region/:sub_region/:city/guide/:market/:submarket' => 'vertical_markets#guide', as: :city_sub_market_guide

  match 'region/:sub_region/:city/search/:market' => 'vertical_markets#search', as: :city_market_search
  match 'region/:sub_region/:city/guide/:market' => 'vertical_markets#guide', as: :city_market_guide

  match 'region/:sub_region/search/:market/:submarket' => 'vertical_markets#search', as: :subregion_sub_market_search
  match 'region/:sub_region/guide/:market/:submarket' => 'vertical_markets#guide', as: :subregion_sub_market_guide

  match 'region/:sub_region/search/:market' => 'vertical_markets#search', as: :subregion_market_search
  match 'region/:sub_region/guide/:market' => 'vertical_markets#guide', as: :subregion_market_guide

  match 'search/:market/:sub_market' => 'vertical_markets#search', as: :region_sub_market_search
  match 'guide/:market/:sub_market' => 'vertical_markets#guide', as: :region_sub_market_guide

  match 'search/:market' => 'vertical_markets#search', as: :region_market_search
  match 'guide/:market' => 'vertical_markets#guide', as: :region_market_guide

  match 'region/:sub_region/:city/:district' => 'districts#homepage', as: :district_guide
  match 'region/:sub_region/:city' => 'cities#homepage', as: :city_guide
  match 'region/:sub_region' => 'sub_regions#homepage', as: :subregion_guide

  match 'category/:id' => 'vertical_market_categories#show'

  match 'profile' => 'profile#show'

  match '/js/autocomplete/users' => 'autocomplete#users', :as => :users_autocomplete

#ActiveAdmin.routes(self)

  root :to => "home#index"


end
