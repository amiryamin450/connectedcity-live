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

ActiveRecord::Schema.define(:version => 20220630085912) do

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

  create_table "automotive_listings", :force => true do |t|
    t.string   "title"
    t.string   "status"
    t.string   "vehicle_type"
    t.boolean  "local"
    t.boolean  "accident"
    t.integer  "price_cents"
    t.integer  "year"
    t.string   "make"
    t.string   "model"
    t.string   "trim_level"
    t.string   "exterior_color"
    t.string   "interior_color"
    t.string   "enigine"
    t.string   "drivetrain"
    t.string   "transmission"
    t.string   "body"
    t.integer  "mileage"
    t.string   "stock_number"
    t.text     "description"
    t.text     "powertrain_specs"
    t.text     "suspension_specs"
    t.text     "specs"
    t.text     "entertainment_features"
    t.text     "seats_and_trim"
    t.text     "convenience_features"
    t.text     "body_exterior"
    t.text     "lighting_visibility_instruments"
    t.text     "saftey_and_security"
    t.integer  "location_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size"
    t.datetime "main_image_updated_at"
  end

  create_table "blog_entries", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "slug"
    t.integer  "bloggable_id"
    t.string   "bloggable_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "blog_entries", ["bloggable_id", "bloggable_type"], :name => "index_blog_entries_on_bloggable_id_and_bloggable_type"

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.integer  "business_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "home_page_image_file_name"
    t.string   "home_page_image_content_type"
    t.integer  "home_page_image_file_size"
    t.datetime "home_page_image_updated_at"
    t.string   "website_url"
  end

  add_index "brands", ["business_id"], :name => "index_brands_on_business_id"

  create_table "brands_locations", :id => false, :force => true do |t|
    t.integer "brand_id"
    t.integer "location_id"
  end

  create_table "business_improvement_areas", :force => true do |t|
    t.integer  "district_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "home_page_image_file_name"
    t.string   "home_page_image_content_type"
    t.integer  "home_page_image_file_size"
    t.datetime "home_page_image_updated_at"
    t.string   "slug"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "user_id"
    t.string   "website_url"
    t.boolean  "use_carousel",                 :default => false
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

  create_table "carousel_images", :force => true do |t|
    t.string   "title"
    t.string   "caption"
    t.integer  "carouselable_id"
    t.string   "carouselable_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "url"
  end

  add_index "carousel_images", ["carouselable_id", "carouselable_type"], :name => "index_carousel_images_on_carouselable_id_and_carouselable_type"

  create_table "carts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories_products", :force => true do |t|
    t.integer  "category_id"
    t.integer  "product_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "categories_status_updates", :force => true do |t|
    t.integer  "category_id"
    t.integer  "status_update_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "cities_old", :force => true do |t|
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

  add_index "cities_old", ["community_id"], :name => "community_id"
  add_index "cities_old", ["province_id"], :name => "province_id"
  add_index "cities_old", ["region_id"], :name => "region_id"
  add_index "cities_old", ["slug"], :name => "index_cities_on_slug"
  add_index "cities_old", ["slug"], :name => "slug"

  create_table "city_news_articles", :force => true do |t|
    t.text     "content"
    t.string   "title"
    t.integer  "city_news_category_id"
    t.integer  "city_id"
    t.integer  "district_id"
    t.integer  "neighborhood_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "slug"
  end

  create_table "city_news_categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "heading_color"
  end

  create_table "classified_categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "heading_color"
    t.integer  "weight"
  end

  create_table "classified_images", :force => true do |t|
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "classified_listing_id"
  end

  create_table "classified_listings", :force => true do |t|
    t.string   "title"
    t.integer  "condition"
    t.text     "description"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "classified_category_id"
    t.integer  "user_id"
    t.integer  "price_cents"
    t.string   "address"
    t.string   "address_1"
    t.integer  "city_id"
    t.integer  "province_id"
    t.string   "postal_code"
    t.integer  "neighborhood_id"
    t.boolean  "active"
  end

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

  create_table "coupons", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "expiration"
    t.integer  "howmany"
    t.integer  "redemptions_count",  :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "location_id"
    t.string   "code_prefix"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

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
    t.boolean  "use_carousel"
  end

  add_index "districts", ["city_id"], :name => "city_id"
  add_index "districts", ["slug"], :name => "slug"

  create_table "districts_copy", :force => true do |t|
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

  add_index "districts_copy", ["city_id"], :name => "city_id"
  add_index "districts_copy", ["slug"], :name => "slug"

  create_table "employment_categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "heading_color"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "employment_listings", :force => true do |t|
    t.string   "title"
    t.string   "number"
    t.text     "locations"
    t.text     "description"
    t.text     "advantages"
    t.text     "qualifications"
    t.integer  "number_of_positions"
    t.date     "application_deadline"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "location_id"
    t.integer  "employment_category_id"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
  end

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
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "user_id"
    t.integer  "vertical_market_id"
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

  create_table "line_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.integer  "quantity",   :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "line_items", ["cart_id"], :name => "index_line_items_on_cart_id"
  add_index "line_items", ["product_id"], :name => "index_line_items_on_product_id"

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

  create_table "location_menus", :force => true do |t|
    t.string   "caption"
    t.integer  "location_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

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
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
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
    t.integer  "neighborhood_id"
    t.integer  "broker_id"
    t.integer  "business_improvement_area_id"
    t.boolean  "claim_pending",                :default => false, :null => false
    t.integer  "payment_user_id"
    t.string   "stripe_plan_id"
    t.string   "stripe_subscription_id"
    t.integer  "hall_id"
    t.integer  "councillor_id"
    t.integer  "commissioner_id"
  end

  add_index "locations", ["city_id"], :name => "city_id"
  add_index "locations", ["community_id"], :name => "community_id"
  add_index "locations", ["country_id"], :name => "country_id"
  add_index "locations", ["province_id"], :name => "province_id"
  add_index "locations", ["region_id"], :name => "region_id"
  add_index "locations", ["slug"], :name => "index_slug"
  add_index "locations", ["yp_lid"], :name => "index_locations_on_yp_lid"

  create_table "locations_trade_associations", :id => false, :force => true do |t|
    t.integer "trade_association_id"
    t.integer "location_id"
  end

  create_table "locations_vertical_market_categories", :id => false, :force => true do |t|
    t.integer "vertical_market_category_id"
    t.integer "location_id"
  end

  add_index "locations_vertical_market_categories", ["vertical_market_category_id", "location_id"], :name => "lvmc_vertical_market_category_id_location_id", :unique => true

  create_table "mailboxer_conversation_opt_outs", :force => true do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], :name => "index_mailboxer_conversation_opt_outs_on_conversation_id"
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], :name => "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"

  create_table "mailboxer_conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "mailboxer_notifications", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.boolean  "global",               :default => false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], :name => "index_mailboxer_notifications_on_conversation_id"
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], :name => "index_mailboxer_notifications_on_notified_object_id_and_type"
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], :name => "index_mailboxer_notifications_on_sender_id_and_sender_type"
  add_index "mailboxer_notifications", ["type"], :name => "index_mailboxer_notifications_on_type"

  create_table "mailboxer_receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "is_read",                       :default => false
    t.boolean  "trashed",                       :default => false
    t.boolean  "deleted",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "mailboxer_receipts", ["notification_id"], :name => "index_mailboxer_receipts_on_notification_id"
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], :name => "index_mailboxer_receipts_on_receiver_id_and_receiver_type"

  create_table "managers", :force => true do |t|
    t.integer  "location_id", :null => false
    t.integer  "user_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "maponics_division" because of following StandardError
#   Unknown type 'geometry' for column 'geom'

# Could not dump table "maponics_provinces" because of following StandardError
#   Unknown type 'geometry' for column 'geom'

# Could not dump table "maponics_subdivisions" because of following StandardError
#   Unknown type 'geometry' for column 'geom'

  create_table "media_attachments", :force => true do |t|
    t.text     "attachment"
    t.text     "attachment_html"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "thumb_url"
    t.string   "title"
    t.string   "media_source_id"
    t.string   "media_source"
    t.boolean  "is_stream_video",               :default => false
    t.string   "archive_id"
    t.string   "session_id"
    t.string   "stream_video_name"
    t.boolean  "has_audio",                     :default => false
    t.boolean  "has_video",                     :default => false
    t.string   "status"
    t.text     "stream_video_url"
    t.string   "description"
    t.string   "stream_thumbnail_file_name"
    t.string   "stream_thumbnail_content_type"
    t.integer  "stream_thumbnail_file_size"
    t.datetime "stream_thumbnail_updated_at"
    t.boolean  "is_draft",        :default => false
  end

  add_index "media_attachments", ["attachable_id", "attachable_type"], :name => "index_media_attachments_on_attachable_id_and_attachable_type"

  create_table "municipalities", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "municipality_code"
    t.integer  "region_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

# Could not dump table "neighborhoods" because of following StandardError
#   Unknown type 'geometry' for column 'geom'

  create_table "new_home_communities", :force => true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.integer  "city_id"
    t.integer  "province_id"
    t.integer  "neighborhood_id"
    t.text     "description"
    t.text     "highlights"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "district_id"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.string   "slug"
    t.string   "address"
    t.string   "postal_code"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "style"
  end

  create_table "new_homes", :force => true do |t|
    t.integer  "location_id"
    t.string   "title"
    t.string   "address"
    t.string   "address_suite"
    t.string   "postal_code"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "slug"
    t.integer  "city_id"
    t.integer  "province_id"
    t.integer  "country_id"
    t.string   "detail_view_url"
    t.string   "virtual_tour_url"
    t.text     "description"
    t.integer  "bedrooms"
    t.integer  "bathrooms"
    t.text     "bedroom_comment"
    t.text     "bathroom_comment"
    t.string   "style"
    t.integer  "living_area"
    t.integer  "year_built"
    t.decimal  "association_fee",          :precision => 10, :scale => 0
    t.string   "association_fee_period"
    t.integer  "neighborhood_id"
    t.decimal  "list_price",               :precision => 10, :scale => 0
    t.decimal  "tax_amount",               :precision => 10, :scale => 0
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.integer  "new_home_community_id"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
  end

  create_table "news_articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "slug"
    t.integer  "newsable_id"
    t.string   "newsable_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "news_articles", ["newsable_id", "newsable_type"], :name => "index_news_articles_on_newsable_id_and_newsable_type"

  create_table "operating_hours", :force => true do |t|
    t.integer  "day",                            :null => false
    t.time     "starts_at"
    t.time     "ends_at"
    t.boolean  "closed",      :default => false
    t.integer  "location_id",                    :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "product_images", ["product_id"], :name => "index_product_images_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "sku"
    t.text     "description"
    t.decimal  "price",              :precision => 10, :scale => 2
    t.string   "slug"
    t.integer  "location_id"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "custom_pricing"
    t.integer  "quantity"
    t.decimal  "discount",           :precision => 10, :scale => 0, :default => 0
    t.integer  "category_id",                                                      :null => false
  end

  add_index "products", ["location_id"], :name => "index_products_on_location_id"

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.string   "slug"
    t.string   "country_code"
    t.string   "country_name"
    t.string   "province_code"
    t.integer  "country_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "provinces_old", :force => true do |t|
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

  add_index "provinces_old", ["country_code"], :name => "index_country_code"
  add_index "provinces_old", ["country_id"], :name => "index_province_country_id"
  add_index "provinces_old", ["slug"], :name => "index_state_or_provinces_on_slug"

  create_table "provinces_regions_old", :id => false, :force => true do |t|
    t.integer "region_id"
    t.integer "province_id"
  end

  create_table "real_estate_listing_images", :force => true do |t|
    t.integer  "real_estate_listing_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

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
    t.text     "description"
    t.decimal  "list_price",                  :precision => 10, :scale => 0
    t.decimal  "tax_amount",                  :precision => 10, :scale => 0
    t.string   "property_type"
    t.string   "style"
    t.text     "lot_comment"
    t.text     "lot_legal"
    t.decimal  "rental_price",                :precision => 10, :scale => 0
    t.string   "rental_period"
    t.string   "rental_currency"
    t.integer  "bedrooms"
    t.text     "bedroom_comment"
    t.integer  "bathrooms"
    t.text     "bathroom_comment"
    t.string   "garage"
    t.integer  "garage_stalls"
    t.string   "garage_style"
    t.text     "garage_comment"
    t.string   "living_area"
    t.decimal  "living_area_unit",            :precision => 10, :scale => 0
    t.integer  "year_built"
    t.text     "year_built_comment"
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
    t.integer  "district_id"
    t.integer  "neighborhood_id"
  end

  add_index "real_estate_listings", ["city_id"], :name => "index_real_estate_listings_on_city_id"
  add_index "real_estate_listings", ["country_id"], :name => "index_real_estate_listings_on_country_id"
  add_index "real_estate_listings", ["province_id"], :name => "index_real_estate_listings_on_province_id"
  add_index "real_estate_listings", ["slug"], :name => "index_real_estate_listings_on_slug"

  create_table "redemptions", :force => true do |t|
    t.integer  "coupon_id"
    t.integer  "user_id"
    t.string   "transaction_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.boolean  "redeemed"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "region_code"
    t.string   "subdomain"
    t.integer  "province_id"
    t.boolean  "show_in_menu"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "regions_old", :force => true do |t|
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

  add_index "regions_old", ["region_code"], :name => "region_code"
  add_index "regions_old", ["slug"], :name => "index_regions_on_slug"
  add_index "regions_old", ["subdomain"], :name => "subdomain"

  create_table "rental_properties", :force => true do |t|
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "postal_code"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "website_url"
    t.integer  "neighborhood_id"
    t.text     "neighborhood_description"
    t.integer  "province_id"
    t.integer  "city_id"
    t.string   "tag_line"
    t.text     "description"
    t.text     "neighborhood_highlights"
    t.text     "property_highlights"
    t.string   "facebook_url"
    t.boolean  "active"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "pov"
    t.string   "slug"
    t.string   "phone_count"
    t.text     "property_features"
    t.text     "garage_types"
    t.text     "included_utilities"
    t.text     "pet_restrictions"
    t.text     "restrictions"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "location_id"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.integer  "district_id"
    t.string   "style"
  end

  create_table "rental_units", :force => true do |t|
    t.integer  "availability"
    t.integer  "bathrooms"
    t.integer  "bedrooms"
    t.integer  "property_id"
    t.date     "date_available"
    t.text     "description"
    t.decimal  "rent_amount",              :precision => 10, :scale => 0
    t.integer  "living_area"
    t.string   "unit_number"
    t.text     "included_appliances"
    t.text     "flooring_types"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.integer  "rental_property_id"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.string   "style"
  end

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

  create_table "social_profiles", :force => true do |t|
    t.integer  "social_network",      :null => false
    t.string   "uid",                 :null => false
    t.string   "access_token",        :null => false
    t.string   "access_token_secret"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "status_updates", :force => true do |t|
    t.string   "title"
    t.string   "content"
    t.string   "provider"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "statusable_id"
    t.string   "statusable_type"
    t.integer  "district_id"
    t.integer  "neighborhood_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "city_id"
    t.integer  "province_id"
    t.string   "vertical_markets"
    t.string   "vertical_market_categories"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "category_id"
  end

  add_index "status_updates", ["statusable_type", "statusable_id"], :name => "index_status_updates_on_statusable_type_and_statusable_id"

  create_table "sub_regions_old", :force => true do |t|
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

  add_index "sub_regions_old", ["region_id"], :name => "region_id"
  add_index "sub_regions_old", ["slug"], :name => "slug"

  create_table "trade_associations", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "city_id"
    t.integer  "province_id"
    t.string   "slug"
    t.string   "website_url"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "home_page_image_file_name"
    t.string   "home_page_image_content_type"
    t.integer  "home_page_image_file_size"
    t.datetime "home_page_image_updated_at"
  end

  add_index "trade_associations", ["city_id"], :name => "index_trade_associations_on_city_id"
  add_index "trade_associations", ["province_id"], :name => "index_trade_associations_on_province_id"

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "username"
    t.string   "provider"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "stripe_customer_id"
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

  add_index "vertical_market_categories", ["vertical_market_id"], :name => "index_vertical_market_categories_on_vertical_market_id"

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

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.text     "video_url"
    t.integer  "status"
    t.datetime "timestamp_thumbnail"
    t.boolean  "updated_audio",          :default => false
    t.string   "resolution"
    t.string   "frame_rate"
    t.string   "session_id"
    t.string   "archive_id"
    t.boolean  "has_audio"
    t.boolean  "has_video"
    t.boolean  "livestream",             :default => false
    t.integer  "attachment_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", name: "mb_opt_outs_on_conversations_id", column: "conversation_id"

  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", name: "notifications_on_conversation_id", column: "conversation_id"

  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", name: "receipts_on_notification_id", column: "notification_id"

end
