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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180306094937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "intarray"

  create_table "admin_notifications", force: :cascade do |t|
    t.string   "description"
    t.datetime "sent_at"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_admin_notifications_on_user_id", using: :btree
  end

  create_table "admins", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "last_activity_at"
  end

  create_table "auth_tokens", force: :cascade do |t|
    t.string   "token"
    t.string   "auth_tokenable_type"
    t.integer  "auth_tokenable_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["auth_tokenable_type", "auth_tokenable_id"], name: "index_auth_tokens_on_auth_tokenable_type_and_auth_tokenable_id", using: :btree
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.string  "external_id"
    t.string  "account_name"
    t.string  "bank_name"
    t.string  "holder_type"
    t.string  "account_type"
    t.string  "account_number"
    t.string  "routing_number"
    t.string  "country"
    t.integer "wedding_id"
    t.integer "vendor_id"
    t.index ["vendor_id"], name: "index_bank_accounts_on_vendor_id", using: :btree
    t.index ["wedding_id"], name: "index_bank_accounts_on_wedding_id", using: :btree
  end

  create_table "bank_cards", force: :cascade do |t|
    t.string  "card_type"
    t.string  "full_name"
    t.string  "number"
    t.string  "expiry_month"
    t.string  "expiry_year"
    t.string  "external_id"
    t.integer "wedding_id"
    t.index ["wedding_id"], name: "index_bank_cards_on_wedding_id", using: :btree
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "schedule"
    t.string   "client"
    t.string   "location"
    t.string   "details"
    t.integer  "vendor_id"
    t.integer  "wedding_id"
    t.integer  "quote_id"
    t.index ["quote_id"], name: "index_bookings_on_quote_id", using: :btree
    t.index ["vendor_id"], name: "index_bookings_on_vendor_id", using: :btree
    t.index ["wedding_id"], name: "index_bookings_on_wedding_id", using: :btree
  end

  create_table "budgets", force: :cascade do |t|
    t.integer  "guide",      default: 0
    t.integer  "planned",    default: 0
    t.integer  "final",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "wedding_id"
    t.integer  "todo_id"
    t.integer  "actual",     default: 0
    t.integer  "paid",       default: 0
    t.index ["todo_id"], name: "index_budgets_on_todo_id", using: :btree
    t.index ["wedding_id"], name: "index_budgets_on_wedding_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string  "name"
    t.integer "vendors_assigned_with", default: 0
    t.string  "internal_id"
    t.integer "order_rank"
    t.index ["internal_id"], name: "index_categories_on_internal_id", unique: true, using: :btree
  end

  create_table "cms_comments", force: :cascade do |t|
    t.string   "author"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_IP"
    t.text     "content"
    t.string   "approved",       default: "pending"
    t.string   "agent"
    t.string   "typee"
    t.integer  "comment_parent"
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["approved"], name: "index_cms_comments_on_approved", using: :btree
    t.index ["comment_parent"], name: "index_cms_comments_on_comment_parent", using: :btree
    t.index ["post_id"], name: "index_cms_comments_on_post_id", using: :btree
    t.index ["user_id"], name: "index_cms_comments_on_user_id", using: :btree
  end

  create_table "cms_custom_fields", force: :cascade do |t|
    t.string  "object_class"
    t.string  "name"
    t.string  "slug"
    t.integer "objectid"
    t.integer "parent_id"
    t.integer "field_order"
    t.integer "count",        default: 0
    t.boolean "is_repeat",    default: false
    t.text    "description"
    t.string  "status"
    t.index ["object_class"], name: "index_cms_custom_fields_on_object_class", using: :btree
    t.index ["objectid"], name: "index_cms_custom_fields_on_objectid", using: :btree
    t.index ["parent_id"], name: "index_cms_custom_fields_on_parent_id", using: :btree
    t.index ["slug"], name: "index_cms_custom_fields_on_slug", using: :btree
  end

  create_table "cms_custom_fields_relationships", force: :cascade do |t|
    t.integer "objectid"
    t.integer "custom_field_id"
    t.integer "term_order"
    t.string  "object_class"
    t.text    "value"
    t.string  "custom_field_slug"
    t.integer "group_number",      default: 0
    t.index ["custom_field_id"], name: "index_cms_custom_fields_relationships_on_custom_field_id", using: :btree
    t.index ["custom_field_slug"], name: "index_cms_custom_fields_relationships_on_custom_field_slug", using: :btree
    t.index ["object_class"], name: "index_cms_custom_fields_relationships_on_object_class", using: :btree
    t.index ["objectid"], name: "index_cms_custom_fields_relationships_on_objectid", using: :btree
  end

  create_table "cms_metas", force: :cascade do |t|
    t.string  "key"
    t.text    "value"
    t.integer "objectid"
    t.string  "object_class"
    t.index ["key"], name: "index_cms_metas_on_key", using: :btree
    t.index ["object_class"], name: "index_cms_metas_on_object_class", using: :btree
    t.index ["objectid"], name: "index_cms_metas_on_objectid", using: :btree
  end

  create_table "cms_posts", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.text     "content_filtered"
    t.string   "status",           default: "published"
    t.datetime "published_at"
    t.integer  "post_parent"
    t.string   "visibility",       default: "public"
    t.text     "visibility_value"
    t.string   "post_class",       default: "Post"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "user_id"
    t.integer  "post_order",       default: 0
    t.integer  "taxonomy_id"
    t.boolean  "is_feature",       default: false
    t.index ["post_class"], name: "index_cms_posts_on_post_class", using: :btree
    t.index ["post_parent"], name: "index_cms_posts_on_post_parent", using: :btree
    t.index ["slug"], name: "index_cms_posts_on_slug", using: :btree
    t.index ["status"], name: "index_cms_posts_on_status", using: :btree
    t.index ["user_id"], name: "index_cms_posts_on_user_id", using: :btree
  end

  create_table "cms_term_relationships", force: :cascade do |t|
    t.integer "objectid"
    t.integer "term_order"
    t.integer "term_taxonomy_id"
    t.index ["objectid"], name: "index_cms_term_relationships_on_objectid", using: :btree
    t.index ["term_order"], name: "index_cms_term_relationships_on_term_order", using: :btree
    t.index ["term_taxonomy_id"], name: "index_cms_term_relationships_on_term_taxonomy_id", using: :btree
  end

  create_table "cms_term_taxonomy", force: :cascade do |t|
    t.string   "taxonomy"
    t.text     "description"
    t.integer  "parent_id"
    t.integer  "count"
    t.string   "name"
    t.string   "slug"
    t.integer  "term_group"
    t.integer  "term_order"
    t.string   "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.index ["parent_id"], name: "index_cms_term_taxonomy_on_parent_id", using: :btree
    t.index ["slug"], name: "index_cms_term_taxonomy_on_slug", using: :btree
    t.index ["taxonomy"], name: "index_cms_term_taxonomy_on_taxonomy", using: :btree
    t.index ["term_order"], name: "index_cms_term_taxonomy_on_term_order", using: :btree
    t.index ["user_id"], name: "index_cms_term_taxonomy_on_user_id", using: :btree
  end

  create_table "cms_users", force: :cascade do |t|
    t.string   "username"
    t.string   "role",                   default: "client"
    t.string   "email"
    t.string   "slug"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.integer  "parent_id"
    t.datetime "password_reset_sent_at"
    t.datetime "last_login_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "site_id",                default: -1
    t.string   "confirm_email_token"
    t.datetime "confirm_email_sent_at"
    t.boolean  "is_valid_email",         default: true
    t.string   "first_name"
    t.string   "last_name"
    t.index ["email"], name: "index_cms_users_on_email", using: :btree
    t.index ["role"], name: "index_cms_users_on_role", using: :btree
    t.index ["site_id"], name: "index_cms_users_on_site_id", using: :btree
    t.index ["username"], name: "index_cms_users_on_username", using: :btree
  end

  create_table "conversations", force: :cascade do |t|
    t.string   "users_uid",   default: [],              array: true
    t.string   "vendor_uid"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "uid"
    t.string   "wedding_uid"
  end

  create_table "custom_todos", force: :cascade do |t|
    t.integer "wedding_id"
    t.string  "name"
    t.string  "status",            default: "pending"
    t.integer "booking_id"
    t.integer "outside_vendor_id"
    t.integer "planned",           default: 0
    t.integer "timing_min_month"
    t.integer "timing_max_month"
    t.integer "service_id"
    t.string  "service_name"
    t.index ["booking_id"], name: "index_custom_todos_on_booking_id", using: :btree
    t.index ["outside_vendor_id"], name: "index_custom_todos_on_outside_vendor_id", using: :btree
    t.index ["service_id"], name: "index_custom_todos_on_service_id", using: :btree
    t.index ["wedding_id"], name: "index_custom_todos_on_wedding_id", using: :btree
  end

  create_table "discount_items", force: :cascade do |t|
    t.integer "quote_id"
    t.integer "price"
    t.integer "referral_id"
    t.index ["quote_id"], name: "index_discount_items_on_quote_id", using: :btree
    t.index ["referral_id"], name: "index_discount_items_on_referral_id", using: :btree
  end

  create_table "discount_prices", force: :cascade do |t|
    t.string  "description"
    t.decimal "price",       default: "0.0"
  end

  create_table "favorite_vendors", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vendor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_favorite_vendors_on_user_id", using: :btree
    t.index ["vendor_id"], name: "index_favorite_vendors_on_vendor_id", using: :btree
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vendor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_favorites_on_user_id", using: :btree
    t.index ["vendor_id"], name: "index_favorites_on_vendor_id", using: :btree
  end

  create_table "features", force: :cascade do |t|
    t.string   "name"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.string   "token"
    t.string   "inviteable_type"
    t.integer  "inviteable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["inviteable_type", "inviteable_id"], name: "index_invitations_on_inviteable_type_and_inviteable_id", using: :btree
    t.index ["token"], name: "index_invitations_on_token", using: :btree
  end

  create_table "invoices", force: :cascade do |t|
    t.decimal  "amount"
    t.string   "description"
    t.string   "status",      default: "unpaid"
    t.integer  "quote_id"
    t.integer  "wedding_id"
    t.integer  "vendor_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.json     "metadata",    default: {}
    t.datetime "due_at"
    t.string   "invoice_no"
    t.index ["quote_id"], name: "index_invoices_on_quote_id", using: :btree
    t.index ["vendor_id"], name: "index_invoices_on_vendor_id", using: :btree
    t.index ["wedding_id"], name: "index_invoices_on_wedding_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.string  "name"
    t.integer "vendor_id"
    t.index ["vendor_id"], name: "index_locations_on_vendor_id", using: :btree
  end

  create_table "locations_vendors", id: false, force: :cascade do |t|
    t.integer "vendor_id",   null: false
    t.integer "location_id", null: false
    t.index ["vendor_id", "location_id"], name: "index_locations_vendors_on_vendor_id_and_location_id", using: :btree
  end

  create_table "logs", force: :cascade do |t|
    t.string   "ip_address"
    t.integer  "user_id"
    t.integer  "vendor_id"
    t.datetime "created_at", null: false
    t.string   "action"
    t.index ["user_id"], name: "index_logs_on_user_id", using: :btree
    t.index ["vendor_id"], name: "index_logs_on_vendor_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.string   "content"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.integer  "quote_id"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
    t.index ["quote_id"], name: "index_messages_on_quote_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "outside_vendors", force: :cascade do |t|
    t.string   "business_name"
    t.string   "public_contact_name"
    t.string   "address_summary"
    t.string   "email"
    t.string   "website"
    t.string   "primary_phone"
    t.integer  "wedding_id"
    t.decimal  "total_fee"
    t.decimal  "paid",                default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["wedding_id"], name: "index_outside_vendors_on_wedding_id", using: :btree
  end

  create_table "outstanding_todos", force: :cascade do |t|
    t.integer "views",      default: 0
    t.integer "todo_id"
    t.integer "wedding_id"
    t.index ["todo_id"], name: "index_outstanding_todos_on_todo_id", using: :btree
    t.index ["wedding_id"], name: "index_outstanding_todos_on_wedding_id", using: :btree
  end

  create_table "payouts", force: :cascade do |t|
    t.string   "status",            default: "pending"
    t.integer  "amount",                                null: false
    t.datetime "scheduled_at"
    t.integer  "rescheduled_count", default: 0,         null: false
    t.json     "metadata",          default: {}
    t.integer  "quote_id"
    t.integer  "vendor_id"
    t.integer  "transaction_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["quote_id"], name: "index_payouts_on_quote_id", using: :btree
    t.index ["transaction_id"], name: "index_payouts_on_transaction_id", using: :btree
    t.index ["vendor_id"], name: "index_payouts_on_vendor_id", using: :btree
  end

  create_table "photos", force: :cascade do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "imageable_type"
    t.integer  "imageable_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_fingerprint"
    t.index ["imageable_type", "imageable_id"], name: "index_photos_on_imageable_type_and_imageable_id", using: :btree
  end

  create_table "plugins_contact_forms", force: :cascade do |t|
    t.integer  "site_id"
    t.integer  "count"
    t.integer  "parent_id"
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.text     "value"
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pricing_and_packages", force: :cascade do |t|
    t.string   "name"
    t.float    "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "vendor_id"
    t.index ["vendor_id"], name: "index_pricing_and_packages_on_vendor_id", using: :btree
  end

  create_table "quote_items", force: :cascade do |t|
    t.integer "quote_id"
    t.string  "name"
    t.text    "description"
    t.decimal "cost",        default: "0.0"
    t.decimal "total",       default: "0.0"
    t.integer "quantity",    default: 1
    t.index ["quote_id"], name: "index_quote_items_on_quote_id", using: :btree
  end

  create_table "quotes", force: :cascade do |t|
    t.integer  "vendor_id"
    t.integer  "wedding_id"
    t.boolean  "is_gst"
    t.datetime "payment_due"
    t.string   "quote_no"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "status",                 default: "offered"
    t.datetime "delivery_date"
    t.datetime "accepted_at"
    t.datetime "fulfilled_at"
    t.string   "vendor_type",            default: "standard"
    t.integer  "custom_vendor_fee_pcg"
    t.integer  "custom_vendor_fee_flat"
    t.datetime "expires_at"
    t.index ["vendor_id"], name: "index_quotes_on_vendor_id", using: :btree
    t.index ["wedding_id"], name: "index_quotes_on_wedding_id", using: :btree
  end

  create_table "referral_codes", force: :cascade do |t|
    t.string   "code"
    t.integer  "accumulated_credit",    default: 0
    t.integer  "current_credit",        default: 0
    t.integer  "times_used",            default: 0
    t.string   "owner_type"
    t.integer  "owner_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "accumulated_gift_card", default: 0
    t.index ["owner_type", "owner_id"], name: "index_referral_codes_on_owner_type_and_owner_id", using: :btree
  end

  create_table "referrals", force: :cascade do |t|
    t.string   "referred_email"
    t.string   "status",          default: "pending"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "referrer_type"
    t.integer  "referrer_id"
    t.datetime "registered_date"
    t.boolean  "gift_card_sent",  default: false
    t.boolean  "notified",        default: false
    t.index ["referrer_type", "referrer_id"], name: "index_referrals_on_referrer_type_and_referrer_id", using: :btree
  end

  create_table "reward_transactions", force: :cascade do |t|
    t.integer  "quote_id"
    t.integer  "wedding_id"
    t.boolean  "gift_card_sent", default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "notified",       default: false
    t.index ["quote_id"], name: "index_reward_transactions_on_quote_id", using: :btree
    t.index ["wedding_id"], name: "index_reward_transactions_on_wedding_id", using: :btree
  end

  create_table "rewards", force: :cascade do |t|
    t.integer  "wedding_id"
    t.integer  "credit",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["wedding_id"], name: "index_rewards_on_wedding_id", using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_primary",  default: true
    t.integer  "category_id"
    t.integer  "order_rank",  default: 1
    t.index ["category_id"], name: "index_services_on_category_id", using: :btree
  end

  create_table "services_vendors", id: false, force: :cascade do |t|
    t.integer "vendor_id",  null: false
    t.integer "service_id", null: false
    t.index ["vendor_id", "service_id"], name: "index_services_vendors_on_vendor_id_and_service_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string  "name"
    t.string  "value"
    t.string  "owner_type"
    t.integer "owner_id"
    t.index ["owner_type", "owner_id"], name: "index_settings_on_owner_type_and_owner_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "todo_notes", force: :cascade do |t|
    t.integer  "wedding_id"
    t.string   "noteable_type"
    t.integer  "noteable_id"
    t.text     "content"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["noteable_type", "noteable_id"], name: "index_todo_notes_on_noteable_type_and_noteable_id", using: :btree
    t.index ["wedding_id"], name: "index_todo_notes_on_wedding_id", using: :btree
  end

  create_table "todo_statuses", force: :cascade do |t|
    t.integer  "wedding_id"
    t.integer  "todo_id"
    t.string   "status",            default: "pending"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "booking_id"
    t.integer  "outside_vendor_id"
    t.index ["booking_id"], name: "index_todo_statuses_on_booking_id", using: :btree
    t.index ["outside_vendor_id"], name: "index_todo_statuses_on_outside_vendor_id", using: :btree
  end

  create_table "todos", force: :cascade do |t|
    t.string  "name"
    t.json    "suggestion_copy",  default: {}
    t.string  "reminder_copy"
    t.string  "question_copy"
    t.string  "redirect_copy"
    t.integer "timing_min_month"
    t.integer "timing_max_month"
    t.decimal "budget_percent"
    t.boolean "is_initial_plan"
    t.integer "service_id"
    t.integer "position"
    t.index ["service_id"], name: "index_todos_on_service_id", using: :btree
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal  "amount"
    t.string   "description"
    t.json     "metadata",        default: {}
    t.string   "owner_type"
    t.integer  "owner_id"
    t.integer  "quote_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "status",          default: "payment received"
    t.decimal  "application_fee"
    t.integer  "invoice_id"
    t.string   "transaction_no"
    t.index ["invoice_id"], name: "index_transactions_on_invoice_id", using: :btree
    t.index ["owner_type", "owner_id"], name: "index_transactions_on_owner_type_and_owner_id", using: :btree
    t.index ["quote_id"], name: "index_transactions_on_quote_id", using: :btree
  end

  create_table "unavailable_dates", force: :cascade do |t|
    t.date     "date"
    t.string   "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "vendor_id"
    t.index ["vendor_id"], name: "index_unavailable_dates_on_vendor_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "uid"
    t.integer  "wedding_id"
    t.string   "gender"
    t.string   "lastname"
    t.json     "metadata_event",               default: {}
    t.string   "profile_photo_file_name"
    t.string   "profile_photo_content_type"
    t.integer  "profile_photo_file_size"
    t.datetime "profile_photo_updated_at"
    t.string   "role"
    t.string   "confirmation_token"
    t.datetime "confirmation_token_sent_at"
    t.boolean  "is_confirmed",                 default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_token_sent_at"
    t.boolean  "welcome_flg",                  default: true
    t.datetime "last_activity_at"
    t.string   "phone"
    t.index ["wedding_id"], name: "index_users_on_wedding_id", using: :btree
  end

  create_table "vendors", force: :cascade do |t|
    t.string   "business_name"
    t.string   "business_number"
    t.string   "email"
    t.string   "invitation_code"
    t.string   "website"
    t.json     "social_channels"
    t.boolean  "insurance"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "suburb"
    t.string   "address_summary"
    t.string   "primary_phone"
    t.string   "secondary_phone"
    t.string   "contact_name"
    t.string   "about"
    t.string   "public_contact_name"
    t.string   "vendor_services",            default: [],                      array: true
    t.boolean  "registered_for_gst"
    t.string   "profile_photo_file_name"
    t.string   "profile_photo_content_type"
    t.integer  "profile_photo_file_size"
    t.datetime "profile_photo_updated_at"
    t.string   "profile_photo_fingerprint"
    t.string   "internal_id"
    t.string   "uid"
    t.string   "registered_trading_name"
    t.integer  "user_id"
    t.string   "slug"
    t.decimal  "address_lat"
    t.decimal  "address_lng"
    t.integer  "primary_service_id"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.string   "cover_photo_fingerprint"
    t.string   "stripe_account_id"
    t.boolean  "searchable",                 default: true
    t.string   "registered_street_address"
    t.string   "state"
    t.string   "registered_country"
    t.string   "registered_post_code"
    t.string   "registered_suburb"
    t.string   "registered_state"
    t.integer  "custom_vendor_fee_flat"
    t.integer  "custom_vendor_fee_pcg"
    t.string   "vendor_type",                default: "standard"
    t.boolean  "anchor",                     default: false
    t.string   "firstname"
    t.string   "lastname"
    t.index ["business_number", "internal_id"], name: "index_vendors_on_business_number_and_internal_id", unique: true, using: :btree
    t.index ["uid"], name: "index_vendors_on_uid", using: :btree
    t.index ["user_id"], name: "index_vendors_on_user_id", using: :btree
  end

  create_table "weddings", force: :cascade do |t|
    t.integer  "budget",            default: 0
    t.string   "location"
    t.date     "date"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "no_of_guests"
    t.string   "status",            default: "active"
    t.string   "uid"
    t.string   "stripe_account_id"
  end

  add_foreign_key "bookings", "vendors"
end
