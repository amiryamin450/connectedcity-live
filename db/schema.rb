# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130819233545) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "attachments", ["attachable_id", "attachable_type"], :name => "index_attachments_on_attachable_id_and_attachable_type"

  create_table "blog_entries", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "slug"
    t.integer  "bloggable_id"
    t.string   "bloggable_type"
  end

  add_index "blog_entries", ["bloggable_id", "bloggable_type"], :name => "index_blog_entries_on_bloggable_id_and_bloggable_type"

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.integer  "business_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "brands", ["business_id"], :name => "index_brands_on_business_id"

  create_table "brands_locations", :id => false, :force => true do |t|
    t.integer "brand_id"
    t.integer "location_id"
  end

  create_table "businesses", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "address_1"
    t.integer  "city_id"
    t.integer  "province_id"
    t.string   "postal_code"
    t.integer  "country_id"
    t.string   "phone"
    t.string   "alt_phone"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.string   "contact_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "businesses_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "business_id"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "community_id"
    t.integer  "province_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "slug"
    t.integer  "region_id"
    t.integer  "sub_region_id"
    t.integer  "region_code"
    t.string   "home_page_image_file_name"
    t.string   "home_page_image_content_type"
    t.integer  "home_page_image_file_size"
    t.datetime "home_page_image_updated_at"
  end

  add_index "cities", ["community_id"], :name => "community_id"
  add_index "cities", ["province_id"], :name => "province_id"
  add_index "cities", ["region_id"], :name => "region_id"
  add_index "cities", ["slug"], :name => "index_cities_on_slug"
  add_index "cities", ["slug"], :name => "slug"

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "region_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "slug"
  end

  add_index "communities", ["region_id"], :name => "region_id"
  add_index "communities", ["slug"], :name => "index_communities_on_slug"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "country_code"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "slug"
  end

  add_index "countries", ["country_code"], :name => "country_code"
  add_index "countries", ["slug"], :name => "index_countries_on_slug"

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "city_id"
    t.string   "slug"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "home_page_image_file_name"
    t.string   "home_page_image_content_type"
    t.integer  "home_page_image_file_size"
    t.datetime "home_page_image_updated_at"
  end

  add_index "districts", ["city_id"], :name => "city_id"
  add_index "districts", ["slug"], :name => "slug"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "email"
    t.string   "url"
    t.integer  "location_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "slug"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "events", ["location_id"], :name => "index_events_on_location_id"

  create_table "favorites", :force => true do |t|
    t.integer  "location_id"
    t.string   "category"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "location_images", :force => true do |t|
    t.string   "caption"
    t.integer  "location_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "location_images", ["location_id"], :name => "location_id"

  create_table "locations", :force => true do |t|
    t.integer  "business_id"
    t.integer  "country_id"
    t.integer  "province_id"
    t.integer  "city_id"
    t.integer  "community_id"
    t.integer  "region_id"
    t.string   "name"
    t.string   "address"
    t.string   "address_1"
    t.string   "postal_code"
    t.string   "phone"
    t.boolean  "show_phone"
    t.string   "toll_free"
    t.boolean  "show_toll_free"
    t.string   "fax"
    t.boolean  "show_fax"
    t.string   "email"
    t.string   "website_url"
    t.string   "import_hash"
    t.boolean  "imported"
    t.string   "slug"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "vertical_market_category_id"
    t.text     "content"
    t.integer  "district_id"
    t.string   "yp_lid"
    t.string   "yp_categories"
    t.string   "yp_neighborhoods"
    t.string   "neighborhood"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
  end

  add_index "locations", ["city_id"], :name => "city_id"
  add_index "locations", ["community_id"], :name => "community_id"
  add_index "locations", ["country_id"], :name => "country_id"
  add_index "locations", ["province_id"], :name => "province_id"
  add_index "locations", ["region_id"], :name => "region_id"
  add_index "locations", ["slug"], :name => "index_slug"
  add_index "locations", ["yp_lid"], :name => "index_locations_on_yp_lid"

  create_table "locations_vertical_market_categories", :id => false, :force => true do |t|
    t.integer "vertical_market_category_id"
    t.integer "location_id"
  end

  create_table "locations_vertical_market_categories_dupes", :id => false, :force => true do |t|
    t.integer "vertical_market_category_id"
    t.integer "location_id"
  end

# Could not dump table "neighborhoods" because of following StandardError
#   Unknown type 'geometry' for column 'geom'

  create_table "news_articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "slug"
    t.integer  "newsable_id"
    t.string   "newsable_type"
  end

  add_index "news_articles", ["newsable_id", "newsable_type"], :name => "index_news_articles_on_newsable_id_and_newsable_type"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "sku"
    t.text     "description"
    t.decimal  "price",              :precision => 10, :scale => 0
    t.string   "slug"
    t.integer  "location_id"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "products", ["location_id"], :name => "index_products_on_location_id"

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "country_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "slug"
    t.string   "country_code"
    t.string   "country_name"
    t.string   "province_code"
  end

  add_index "provinces", ["country_code"], :name => "index_country_code"
  add_index "provinces", ["country_id"], :name => "index_province_country_id"
  add_index "provinces", ["slug"], :name => "index_state_or_provinces_on_slug"

  create_table "provinces_regions", :id => false, :force => true do |t|
    t.integer "region_id"
    t.integer "province_id"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "real_estate_listings", :force => true do |t|
    t.string   "listing_source"
    t.string   "email"
    t.string   "web_bug_url"
    t.integer  "listing_source_id"
    t.string   "provider_listing_id"
    t.string   "provider"
    t.string   "regional_mls_number"
    t.boolean  "regional_mls_number_visible"
    t.datetime "last_update_date"
    t.string   "status"
    t.string   "title"
    t.string   "detail_view_url"
    t.integer  "country_id"
    t.integer  "province_id"
    t.string   "address"
    t.boolean  "address_visible"
    t.string   "address_suite"
    t.string   "postal_code"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "city_id"
    t.string   "description"
    t.decimal  "list_price",                  :precision => 10, :scale => 0
    t.decimal  "tax_amount",                  :precision => 10, :scale => 0
    t.string   "property_type"
    t.string   "style"
    t.string   "lot_comment"
    t.string   "lot_legal"
    t.decimal  "rental_price",                :precision => 10, :scale => 0
    t.string   "rental_period"
    t.string   "rental_currency"
    t.integer  "bedrooms"
    t.string   "bedroom_comment"
    t.integer  "bathrooms"
    t.string   "bathroom_comment"
    t.string   "garage"
    t.integer  "garage_stalls"
    t.string   "garage_style"
    t.string   "garage_comment"
    t.string   "living_area"
    t.decimal  "living_area_unit",            :precision => 10, :scale => 0
    t.integer  "year_built"
    t.string   "year_built_comment"
    t.string   "broker_name"
    t.datetime "list_date"
    t.string   "virtual_tour_url"
    t.decimal  "association_fee",             :precision => 10, :scale => 0
    t.string   "association_fee_period"
    t.string   "association_fee_currency"
    t.string   "neighborhood"
    t.integer  "location_id"
    t.string   "slug"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size"
    t.datetime "main_image_updated_at"
  end

  add_index "real_estate_listings", ["city_id"], :name => "index_real_estate_listings_on_city_id"
  add_index "real_estate_listings", ["country_id"], :name => "index_real_estate_listings_on_country_id"
  add_index "real_estate_listings", ["province_id"], :name => "index_real_estate_listings_on_province_id"
  add_index "real_estate_listings", ["slug"], :name => "index_real_estate_listings_on_slug"

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "slug"
    t.integer  "region_code"
    t.string   "subdomain"
    t.boolean  "show_in_menu"
    t.string   "home_page_image_file_name"
    t.string   "home_page_image_content_type"
    t.integer  "home_page_image_file_size"
    t.datetime "home_page_image_updated_at"
  end

  add_index "regions", ["region_code"], :name => "region_code"
  add_index "regions", ["slug"], :name => "index_regions_on_slug"
  add_index "regions", ["subdomain"], :name => "subdomain"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "services", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "location_id"
    t.string   "sku"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "slug"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.decimal  "price",              :precision => 10, :scale => 0
  end

  add_index "services", ["location_id"], :name => "index_services_on_location_id"

  create_table "status_updates", :force => true do |t|
    t.string   "title"
    t.string   "content"
    t.string   "provider"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "statusable_id"
    t.string   "statusable_type"
  end

  add_index "status_updates", ["statusable_type", "statusable_id"], :name => "index_status_updates_on_statusable_type_and_statusable_id"

  create_table "sub_regions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.integer  "region_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "home_page_image_file_name"
    t.string   "home_page_image_content_type"
    t.integer  "home_page_image_file_size"
    t.datetime "home_page_image_updated_at"
  end

  add_index "sub_regions", ["region_id"], :name => "region_id"
  add_index "sub_regions", ["slug"], :name => "slug"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "username"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "vertical_market_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.integer  "vertical_market_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "default_logo_file_name"
    t.string   "default_logo_content_type"
    t.integer  "default_logo_file_size"
    t.datetime "default_logo_updated_at"
    t.string   "search_term"
  end

  create_table "vertical_markets", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "ancestry"
    t.integer  "ancestry_depth", :default => 0
    t.integer  "weight"
  end

  add_index "vertical_markets", ["ancestry"], :name => "index_vertical_markets_on_ancestry"
  add_index "vertical_markets", ["slug"], :name => "index_vertical_markets_on_slug", :unique => true

end
