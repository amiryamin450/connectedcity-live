# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_06_12_042059) do
  create_table "active_admin_comments", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.integer "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "namespace"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id"
  end

  create_table "admin_users", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "attachments", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "attachable_id"
    t.string "attachable_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.index ["attachable_id", "attachable_type"], name: "index_attachments_on_attachable_id_and_attachable_type"
  end

  create_table "automotive_listings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "title"
    t.string "status"
    t.string "vehicle_type"
    t.boolean "local"
    t.boolean "accident"
    t.integer "price_cents"
    t.integer "year"
    t.string "make"
    t.string "model"
    t.string "trim_level"
    t.string "exterior_color"
    t.string "interior_color"
    t.string "enigine"
    t.string "drivetrain"
    t.string "transmission"
    t.string "body"
    t.integer "mileage"
    t.string "stock_number"
    t.text "description"
    t.text "powertrain_specs"
    t.text "suspension_specs"
    t.text "specs"
    t.text "entertainment_features"
    t.text "seats_and_trim"
    t.text "convenience_features"
    t.text "body_exterior"
    t.text "lighting_visibility_instruments"
    t.text "saftey_and_security"
    t.integer "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "main_image_file_name"
    t.string "main_image_content_type"
    t.integer "main_image_file_size"
    t.datetime "main_image_updated_at", precision: nil
  end

  create_table "blog_entries", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.integer "bloggable_id"
    t.string "bloggable_type"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.index ["bloggable_id", "bloggable_type"], name: "index_blog_entries_on_bloggable_id_and_bloggable_type"
  end

  create_table "brands", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug"
    t.integer "business_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at", precision: nil
    t.string "home_page_image_file_name"
    t.string "home_page_image_content_type"
    t.integer "home_page_image_file_size"
    t.datetime "home_page_image_updated_at", precision: nil
    t.string "website_url"
    t.index ["business_id"], name: "index_brands_on_business_id"
  end

  create_table "brands_locations", id: false, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "brand_id"
    t.integer "location_id"
  end

  create_table "business_improvement_areas", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "district_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "home_page_image_file_name"
    t.string "home_page_image_content_type"
    t.integer "home_page_image_file_size"
    t.datetime "home_page_image_updated_at", precision: nil
    t.string "slug"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at", precision: nil
    t.integer "user_id"
    t.string "website_url"
    t.boolean "use_carousel", default: false
  end

  create_table "businesses", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "address_1"
    t.integer "city_id"
    t.integer "province_id"
    t.string "postal_code"
    t.integer "country_id"
    t.string "phone"
    t.string "alt_phone"
    t.string "fax"
    t.string "email"
    t.string "website"
    t.string "contact_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "businesses_users", id: false, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "user_id"
    t.integer "business_id"
  end

  create_table "carousel_images", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "title"
    t.string "caption"
    t.integer "carouselable_id"
    t.string "carouselable_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.string "url"
    t.index ["carouselable_id", "carouselable_type"], name: "index_carousel_images_on_carouselable_id_and_carouselable_type"
  end

  create_table "carts", id: :integer, charset: "latin1", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "categories_products", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "category_id"
    t.integer "product_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "categories_status_updates", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "category_id"
    t.integer "status_update_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "cities_old", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "community_id"
    t.integer "province_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.integer "region_id"
    t.integer "sub_region_id"
    t.integer "region_code"
    t.string "home_page_image_file_name"
    t.string "home_page_image_content_type"
    t.integer "home_page_image_file_size"
    t.datetime "home_page_image_updated_at", precision: nil
    t.index ["community_id"], name: "community_id"
    t.index ["province_id"], name: "province_id"
    t.index ["region_id"], name: "region_id"
    t.index ["slug"], name: "index_cities_on_slug"
    t.index ["slug"], name: "slug"
  end

  create_table "city_news_articles", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "content"
    t.string "title"
    t.integer "city_news_category_id"
    t.integer "city_id"
    t.integer "district_id"
    t.integer "neighborhood_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.string "slug"
  end

  create_table "city_news_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "heading_color"
  end

  create_table "classified_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "heading_color"
    t.integer "weight"
  end

  create_table "classified_images", id: :integer, charset: "latin1", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.integer "classified_listing_id"
  end

  create_table "classified_listings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "title"
    t.integer "condition"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "classified_category_id"
    t.integer "user_id"
    t.integer "price_cents"
    t.string "address"
    t.string "address_1"
    t.integer "city_id"
    t.integer "province_id"
    t.string "postal_code"
    t.integer "neighborhood_id"
    t.boolean "active"
  end

  create_table "communities", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "region_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.index ["region_id"], name: "region_id"
    t.index ["slug"], name: "index_communities_on_slug"
  end

  create_table "conversations", charset: "utf8", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id", "sender_id"], name: "index_conversations_on_recipient_id_and_sender_id", unique: true
  end

  create_table "countries", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "country_code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.index ["country_code"], name: "country_code"
    t.index ["slug"], name: "index_countries_on_slug"
  end

  create_table "coupons", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "expiration"
    t.integer "howmany"
    t.integer "redemptions_count", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "location_id"
    t.string "code_prefix"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
  end

  create_table "districts", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "city_id"
    t.string "slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "home_page_image_file_name"
    t.string "home_page_image_content_type"
    t.integer "home_page_image_file_size"
    t.datetime "home_page_image_updated_at", precision: nil
    t.boolean "use_carousel"
    t.index ["city_id"], name: "city_id"
    t.index ["slug"], name: "slug"
  end

  create_table "districts_copy", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "city_id"
    t.string "slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "home_page_image_file_name"
    t.string "home_page_image_content_type"
    t.integer "home_page_image_file_size"
    t.datetime "home_page_image_updated_at", precision: nil
    t.index ["city_id"], name: "city_id"
    t.index ["slug"], name: "slug"
  end

  create_table "employment_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "heading_color"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "employment_listings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "title"
    t.string "number"
    t.text "locations"
    t.text "description"
    t.text "advantages"
    t.text "qualifications"
    t.integer "number_of_positions"
    t.date "application_deadline"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "location_id"
    t.integer "employment_category_id"
    t.string "cover_photo_file_name"
    t.string "cover_photo_content_type"
    t.integer "cover_photo_file_size"
    t.datetime "cover_photo_updated_at", precision: nil
  end

  create_table "events", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "starts_at", precision: nil
    t.datetime "ends_at", precision: nil
    t.string "email"
    t.string "url"
    t.integer "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.integer "category_id"
    t.float "latitude"
    t.float "longitude"
    t.index ["location_id"], name: "index_events_on_location_id"
  end

  create_table "favorites", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "location_id"
    t.string "category"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.integer "vertical_market_id"
  end

  create_table "friendly_id_slugs", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 40
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "line_items", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "product_id"
    t.integer "cart_id"
    t.integer "quantity", default: 1
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "location_id"
    t.boolean "paid", default: false
    t.bigint "order_id"
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
  end

  create_table "location_images", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "caption"
    t.integer "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.index ["location_id"], name: "location_id"
  end

  create_table "location_menus", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "caption"
    t.integer "location_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "locations", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "business_id"
    t.integer "country_id"
    t.integer "province_id"
    t.integer "city_id"
    t.integer "community_id"
    t.integer "region_id"
    t.string "name"
    t.string "address"
    t.string "address_1"
    t.string "postal_code"
    t.string "phone"
    t.boolean "show_phone"
    t.string "toll_free"
    t.boolean "show_toll_free"
    t.string "fax"
    t.boolean "show_fax"
    t.string "email"
    t.string "website_url"
    t.string "import_hash"
    t.boolean "imported"
    t.string "slug"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at", precision: nil
    t.integer "vertical_market_category_id"
    t.text "content"
    t.integer "district_id"
    t.string "yp_lid"
    t.string "yp_categories"
    t.string "yp_neighborhoods"
    t.string "neighborhood"
    t.string "cover_photo_file_name"
    t.string "cover_photo_content_type"
    t.integer "cover_photo_file_size"
    t.datetime "cover_photo_updated_at", precision: nil
    t.integer "neighborhood_id"
    t.integer "broker_id"
    t.integer "business_improvement_area_id"
    t.boolean "claim_pending", default: false, null: false
    t.integer "payment_user_id"
    t.string "stripe_plan_id"
    t.string "stripe_subscription_id"
    t.integer "hall_id"
    t.integer "councillor_id"
    t.integer "commissioner_id"
    t.integer "sub_neighborhood_id"
    t.boolean "available_call", default: true
    t.integer "municipality_id"
    t.string "stripe_account_id"
    t.boolean "is_profile", default: false
    t.bigint "owner_id"
    t.bigint "super_admin_id"
    t.integer "status", default: 0
    t.integer "user_id"
    t.index ["city_id"], name: "city_id"
    t.index ["community_id"], name: "community_id"
    t.index ["country_id"], name: "country_id"
    t.index ["owner_id"], name: "index_locations_on_owner_id"
    t.index ["province_id"], name: "province_id"
    t.index ["region_id"], name: "region_id"
    t.index ["slug"], name: "index_slug"
    t.index ["super_admin_id"], name: "index_locations_on_super_admin_id"
    t.index ["yp_lid"], name: "index_locations_on_yp_lid"
  end

  create_table "locations_trade_associations", id: false, charset: "latin1", force: :cascade do |t|
    t.integer "trade_association_id"
    t.integer "location_id"
  end

  create_table "locations_vertical_market_categories", id: false, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "vertical_market_category_id"
    t.integer "location_id"
    t.index ["vertical_market_category_id", "location_id"], name: "lvmc_vertical_market_category_id_location_id", unique: true
  end

  create_table "mailboxer_conversation_opt_outs", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string "unsubscriber_type"
    t.integer "conversation_id"
    t.index ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
    t.index ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"
  end

  create_table "mailboxer_conversations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "subject", default: ""
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "mailboxer_notifications", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "type"
    t.text "body"
    t.string "subject", default: ""
    t.integer "sender_id"
    t.string "sender_type"
    t.integer "conversation_id"
    t.boolean "draft", default: false
    t.string "notification_code"
    t.integer "notified_object_id"
    t.string "notified_object_type"
    t.string "attachment"
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.boolean "global", default: false
    t.datetime "expires", precision: nil
    t.index ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"
    t.index ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
    t.index ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
    t.index ["type"], name: "index_mailboxer_notifications_on_type"
  end

  create_table "mailboxer_receipts", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "receiver_id"
    t.string "receiver_type"
    t.integer "notification_id", null: false
    t.boolean "is_read", default: false
    t.boolean "trashed", default: false
    t.boolean "deleted", default: false
    t.string "mailbox_type", limit: 25
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"
    t.index ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"
  end

  create_table "managers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

# Could not dump table "maponics_division" because of following StandardError
#   Unknown type 'geometry' for column 'geom'

# Could not dump table "maponics_provinces" because of following StandardError
#   Unknown type 'geometry' for column 'geom'

# Could not dump table "maponics_subdivisions" because of following StandardError
#   Unknown type 'geometry' for column 'geom'

  create_table "media_attachments", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "attachment"
    t.text "attachment_html"
    t.integer "attachable_id"
    t.string "attachable_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "thumb_url"
    t.string "title"
    t.string "media_source_id"
    t.string "media_source"
    t.boolean "is_stream_video", default: false
    t.string "description"
    t.boolean "is_draft", default: false
    t.integer "category_id"
    t.float "latitude"
    t.float "longitude"
    t.index ["attachable_id", "attachable_type"], name: "index_media_attachments_on_attachable_id_and_attachable_type"
  end

  create_table "messages", charset: "utf8", force: :cascade do |t|
    t.text "body"
    t.bigint "conversation_id"
    t.bigint "sender_id"
    t.boolean "has_seen", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "municipalities", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "municipality_code"
    t.integer "region_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "province_id"
  end

# Could not dump table "neighborhoods" because of following StandardError
#   Unknown type 'geometry' for column 'geom'

  create_table "new_home_communities", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "location_id"
    t.integer "city_id"
    t.integer "province_id"
    t.integer "neighborhood_id"
    t.text "description"
    t.text "highlights"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "district_id"
    t.string "cover_photo_file_name"
    t.string "cover_photo_content_type"
    t.integer "cover_photo_file_size"
    t.datetime "cover_photo_updated_at", precision: nil
    t.string "slug"
    t.string "address"
    t.string "postal_code"
    t.float "latitude"
    t.float "longitude"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at", precision: nil
    t.string "style"
  end

  create_table "new_homes", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "location_id"
    t.string "title"
    t.string "address"
    t.string "address_suite"
    t.string "postal_code"
    t.float "latitude"
    t.float "longitude"
    t.string "slug"
    t.integer "city_id"
    t.integer "province_id"
    t.integer "country_id"
    t.string "detail_view_url"
    t.string "virtual_tour_url"
    t.text "description"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.text "bedroom_comment"
    t.text "bathroom_comment"
    t.string "style"
    t.integer "living_area"
    t.integer "year_built"
    t.decimal "association_fee", precision: 10
    t.string "association_fee_period"
    t.integer "neighborhood_id"
    t.decimal "list_price", precision: 10
    t.decimal "tax_amount", precision: 10
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "new_home_community_id"
    t.string "cover_photo_file_name"
    t.string "cover_photo_content_type"
    t.integer "cover_photo_file_size"
    t.datetime "cover_photo_updated_at", precision: nil
  end

  create_table "news_articles", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.integer "newsable_id"
    t.string "newsable_type"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.integer "category_id"
    t.float "latitude"
    t.float "longitude"
    t.index ["newsable_id", "newsable_type"], name: "index_news_articles_on_newsable_id_and_newsable_type"
  end

  create_table "operating_hours", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "day", null: false
    t.time "starts_at"
    t.time "ends_at"
    t.boolean "closed", default: false
    t.integer "location_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "options", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "variant_id"
    t.string "name"
  end

  create_table "orders", charset: "utf8", force: :cascade do |t|
    t.integer "number"
    t.integer "status", default: 0
    t.string "payment_method"
    t.datetime "confirmed_ready_at"
    t.bigint "customer_id", null: false
    t.bigint "seller_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["seller_id"], name: "index_orders_on_seller_id"
  end

  create_table "product_images", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "product_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "products", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.string "slug"
    t.integer "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.boolean "custom_pricing"
    t.integer "quantity"
    t.decimal "discount", precision: 10, default: "0"
    t.integer "category_id", null: false
    t.index ["location_id"], name: "index_products_on_location_id"
  end

  create_table "provinces", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.string "slug"
    t.string "country_code"
    t.string "country_name"
    t.string "province_code"
    t.integer "country_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.float "tax_pst", default: 0.0
    t.float "tax_gst", default: 0.0
    t.float "tax_hst", default: 0.0
  end

  create_table "provinces_old", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.integer "country_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.string "country_code"
    t.string "country_name"
    t.string "province_code"
    t.index ["country_code"], name: "index_country_code"
    t.index ["country_id"], name: "index_province_country_id"
    t.index ["slug"], name: "index_state_or_provinces_on_slug"
  end

  create_table "provinces_regions_old", id: false, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "region_id"
    t.integer "province_id"
  end

  create_table "real_estate_listing_images", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "real_estate_listing_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
  end

  create_table "real_estate_listings", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "listing_source"
    t.string "email"
    t.string "web_bug_url"
    t.integer "listing_source_id"
    t.string "provider_listing_id"
    t.string "provider"
    t.string "regional_mls_number"
    t.boolean "regional_mls_number_visible"
    t.datetime "last_update_date", precision: nil
    t.string "status"
    t.string "title"
    t.string "detail_view_url"
    t.integer "country_id"
    t.integer "province_id"
    t.string "address"
    t.boolean "address_visible"
    t.string "address_suite"
    t.string "postal_code"
    t.float "latitude"
    t.float "longitude"
    t.integer "city_id"
    t.text "description"
    t.decimal "list_price", precision: 10
    t.decimal "tax_amount", precision: 10
    t.string "property_type"
    t.string "style"
    t.text "lot_comment"
    t.text "lot_legal"
    t.decimal "rental_price", precision: 10
    t.string "rental_period"
    t.string "rental_currency"
    t.integer "bedrooms"
    t.text "bedroom_comment"
    t.integer "bathrooms"
    t.text "bathroom_comment"
    t.string "garage"
    t.integer "garage_stalls"
    t.string "garage_style"
    t.text "garage_comment"
    t.string "living_area"
    t.decimal "living_area_unit", precision: 10
    t.integer "year_built"
    t.text "year_built_comment"
    t.string "broker_name"
    t.datetime "list_date", precision: nil
    t.string "virtual_tour_url"
    t.decimal "association_fee", precision: 10
    t.string "association_fee_period"
    t.string "association_fee_currency"
    t.string "neighborhood"
    t.integer "location_id"
    t.string "slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "main_image_file_name"
    t.string "main_image_content_type"
    t.integer "main_image_file_size"
    t.datetime "main_image_updated_at", precision: nil
    t.integer "district_id"
    t.integer "neighborhood_id"
    t.index ["city_id"], name: "index_real_estate_listings_on_city_id"
    t.index ["country_id"], name: "index_real_estate_listings_on_country_id"
    t.index ["province_id"], name: "index_real_estate_listings_on_province_id"
    t.index ["slug"], name: "index_real_estate_listings_on_slug"
  end

  create_table "redemptions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "coupon_id"
    t.integer "user_id"
    t.string "transaction_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "redeemed"
  end

  create_table "regions", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "region_code"
    t.string "subdomain"
    t.integer "province_id"
    t.boolean "show_in_menu"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "regions_old", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.integer "region_code"
    t.string "subdomain"
    t.boolean "show_in_menu"
    t.string "home_page_image_file_name"
    t.string "home_page_image_content_type"
    t.integer "home_page_image_file_size"
    t.datetime "home_page_image_updated_at", precision: nil
    t.index ["region_code"], name: "region_code"
    t.index ["slug"], name: "index_regions_on_slug"
    t.index ["subdomain"], name: "subdomain"
  end

  create_table "rental_properties", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "address_1"
    t.string "address_2"
    t.string "postal_code"
    t.string "phone"
    t.string "fax"
    t.string "email"
    t.string "website_url"
    t.integer "neighborhood_id"
    t.text "neighborhood_description"
    t.integer "province_id"
    t.integer "city_id"
    t.string "tag_line"
    t.text "description"
    t.text "neighborhood_highlights"
    t.text "property_highlights"
    t.string "facebook_url"
    t.boolean "active"
    t.float "latitude"
    t.float "longitude"
    t.string "pov"
    t.string "slug"
    t.string "phone_count"
    t.text "property_features"
    t.text "garage_types"
    t.text "included_utilities"
    t.text "pet_restrictions"
    t.text "restrictions"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "location_id"
    t.string "cover_photo_file_name"
    t.string "cover_photo_content_type"
    t.integer "cover_photo_file_size"
    t.datetime "cover_photo_updated_at", precision: nil
    t.integer "district_id"
    t.string "style"
  end

  create_table "rental_units", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "availability"
    t.integer "bathrooms"
    t.integer "bedrooms"
    t.integer "property_id"
    t.date "date_available"
    t.text "description"
    t.decimal "rent_amount", precision: 10
    t.integer "living_area"
    t.string "unit_number"
    t.text "included_appliances"
    t.text "flooring_types"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "rental_property_id"
    t.string "cover_photo_file_name"
    t.string "cover_photo_content_type"
    t.integer "cover_photo_file_size"
    t.datetime "cover_photo_updated_at", precision: nil
    t.string "style"
  end

  create_table "roles", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "services", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "location_id"
    t.string "sku"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.decimal "price", precision: 10
    t.index ["location_id"], name: "index_services_on_location_id"
  end

  create_table "shipments", charset: "utf8", force: :cascade do |t|
    t.string "tracking_number"
    t.integer "status", default: 0
    t.integer "delivery_method", default: 0
    t.string "shipping_name"
    t.text "shipping_address"
    t.datetime "shipped_at"
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_shipments_on_order_id"
  end

  create_table "social_profiles", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "social_network", null: false
    t.string "uid", null: false
    t.string "access_token", null: false
    t.string "access_token_secret"
    t.integer "owner_id"
    t.string "owner_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "status_updates", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.string "provider"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "statusable_id"
    t.string "statusable_type"
    t.integer "district_id"
    t.integer "neighborhood_id"
    t.float "latitude"
    t.float "longitude"
    t.integer "city_id"
    t.integer "province_id"
    t.string "vertical_markets"
    t.string "vertical_market_categories"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.integer "category_id"
    t.index ["statusable_type", "statusable_id"], name: "index_status_updates_on_statusable_type_and_statusable_id"
  end

  create_table "sub_regions_old", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug"
    t.integer "region_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "home_page_image_file_name"
    t.string "home_page_image_content_type"
    t.integer "home_page_image_file_size"
    t.datetime "home_page_image_updated_at", precision: nil
    t.index ["region_id"], name: "region_id"
    t.index ["slug"], name: "slug"
  end

  create_table "trade_associations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "city_id"
    t.integer "province_id"
    t.string "slug"
    t.string "website_url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at", precision: nil
    t.string "home_page_image_file_name"
    t.string "home_page_image_content_type"
    t.integer "home_page_image_file_size"
    t.datetime "home_page_image_updated_at", precision: nil
    t.index ["city_id"], name: "index_trade_associations_on_city_id"
    t.index ["province_id"], name: "index_trade_associations_on_province_id"
  end

  create_table "users", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.string "username"
    t.string "provider"
    t.string "uid"
    t.string "first_name"
    t.string "last_name"
    t.string "stripe_customer_id"
    t.integer "cart_id"
    t.string "phone_number"
    t.string "verifying_request_id"
    t.string "google_secret"
    t.boolean "required_otp_for_login", default: false
    t.string "reset_code"
    t.string "address"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  create_table "variants", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "name"
    t.float "price"
    t.string "sku"
  end

  create_table "vertical_market_categories", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug"
    t.integer "vertical_market_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "default_logo_file_name"
    t.string "default_logo_content_type"
    t.integer "default_logo_file_size"
    t.datetime "default_logo_updated_at", precision: nil
    t.string "search_term"
    t.index ["vertical_market_id"], name: "index_vertical_market_categories_on_vertical_market_id"
  end

  create_table "vertical_markets", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.integer "weight"
    t.index ["ancestry"], name: "index_vertical_markets_on_ancestry"
    t.index ["slug"], name: "index_vertical_markets_on_slug", unique: true
  end

  create_table "video_calls", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "session_id"
    t.integer "user_business_id"
    t.string "user_call_id"
    t.string "status", default: "available"
    t.text "token"
    t.integer "location_id"
  end

  create_table "videos", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "thumbnail_file_name"
    t.string "thumbnail_content_type"
    t.integer "thumbnail_file_size"
    t.datetime "thumbnail_updated_at", precision: nil
    t.text "video_url"
    t.string "status"
    t.datetime "timestamp_thumbnail", precision: nil
    t.boolean "updated_audio", default: false
    t.string "resolution"
    t.string "frame_rate"
    t.string "session_id"
    t.string "archive_id"
    t.boolean "has_audio"
    t.boolean "has_video"
    t.boolean "livestream", default: false
    t.integer "media_attachment_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "broadcast_id"
  end

  add_foreign_key "line_items", "orders"
  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
  add_foreign_key "shipments", "orders"
end
