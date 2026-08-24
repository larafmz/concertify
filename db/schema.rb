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

ActiveRecord::Schema[7.2].define(version: 2026_08_24_171822) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.string "ticketmaster_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "genre_id"
    t.bigint "requester_id"
    t.integer "status"
    t.bigint "request_id"
    t.index ["genre_id"], name: "index_artists_on_genre_id"
    t.index ["request_id"], name: "index_artists_on_request_id"
    t.index ["requester_id"], name: "index_artists_on_requester_id"
  end

  create_table "artists_events", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id", "event_id"], name: "index_artists_events_on_artist_id_and_event_id", unique: true
    t.index ["artist_id"], name: "index_artists_events_on_artist_id"
    t.index ["event_id"], name: "index_artists_events_on_event_id"
  end

  create_table "chat_entries", force: :cascade do |t|
    t.string "text"
    t.bigint "chat_id"
    t.bigint "user_id"
    t.bigint "message_father_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chat_type"
    t.index ["chat_id"], name: "index_chat_entries_on_chat_id"
    t.index ["message_father_id"], name: "index_chat_entries_on_message_father_id"
    t.index ["user_id"], name: "index_chat_entries_on_user_id"
  end

  create_table "chat_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "read_at"
    t.index ["chat_id"], name: "index_chat_users_on_chat_id"
    t.index ["user_id", "chat_id"], name: "index_chat_users_on_user_id_and_chat_id", unique: true
    t.index ["user_id"], name: "index_chat_users_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_chats_on_event_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "interactuable_id", null: false
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "comment_father_id"
    t.index ["comment_father_id"], name: "index_comments_on_comment_father_id"
    t.index ["interactuable_id"], name: "index_comments_on_interactuable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "ticketmaster_id"
    t.string "tour_name"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ubication_id"
    t.datetime "start_time"
    t.bigint "request_id"
    t.index ["request_id"], name: "index_events_on_request_id"
    t.index ["ubication_id"], name: "index_events_on_ubication_id"
  end

  create_table "favorite_artists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "artist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_favorite_artists_on_artist_id"
    t.index ["user_id"], name: "index_favorite_artists_on_user_id"
  end

  create_table "future_assistances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.string "from"
    t.integer "event_seat"
    t.string "event_seat_details"
    t.bigint "interactuable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company"
    t.index ["event_id"], name: "index_future_assistances_on_event_id"
    t.index ["interactuable_id"], name: "index_future_assistances_on_interactuable_id"
    t.index ["user_id"], name: "index_future_assistances_on_user_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interactuables", force: :cascade do |t|
    t.string "type"
    t.bigint "user_id", null: false
    t.string "review"
    t.bigint "artist_id"
    t.bigint "event_id"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_interactuables_on_artist_id"
    t.index ["event_id"], name: "index_interactuables_on_event_id"
    t.index ["user_id"], name: "index_interactuables_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "interactuable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interactuable_id"], name: "index_likes_on_interactuable_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "noticed_events", force: :cascade do |t|
    t.string "type"
    t.string "record_type"
    t.bigint "record_id"
    t.jsonb "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notifications_count"
    t.index ["record_type", "record_id"], name: "index_noticed_events_on_record"
  end

  create_table "noticed_notifications", force: :cascade do |t|
    t.string "type"
    t.bigint "event_id", null: false
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.datetime "read_at", precision: nil
    t.datetime "seen_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chat_id"
    t.index ["chat_id"], name: "index_noticed_notifications_on_chat_id"
    t.index ["event_id"], name: "index_noticed_notifications_on_event_id"
    t.index ["recipient_type", "recipient_id"], name: "index_noticed_notifications_on_recipient"
  end

  create_table "relations", force: :cascade do |t|
    t.bigint "follower_id"
    t.integer "relation_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "followed_type", null: false
    t.bigint "followed_id", null: false
    t.index ["followed_type", "followed_id"], name: "index_relations_on_followed"
    t.index ["follower_id"], name: "index_relations_on_follower_id"
  end

  create_table "reposts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "interactuable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interactuable_id"], name: "index_reposts_on_interactuable_id"
    t.index ["user_id"], name: "index_reposts_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "status"
    t.bigint "requester_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message"
    t.index ["requester_id"], name: "index_requests_on_requester_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "tagged_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "interactuable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interactuable_id"], name: "index_tagged_users_on_interactuable_id"
    t.index ["user_id"], name: "index_tagged_users_on_user_id"
  end

  create_table "ubications", force: :cascade do |t|
    t.string "city"
    t.string "state"
    t.string "venue"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["country_id"], name: "index_ubications_on_country_id"
    t.index ["user_id"], name: "index_ubications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "description"
    t.bigint "role_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "artists", "users", column: "requester_id"
  add_foreign_key "artists_events", "artists"
  add_foreign_key "artists_events", "events"
  add_foreign_key "chat_entries", "chat_entries", column: "message_father_id"
  add_foreign_key "chat_users", "chats"
  add_foreign_key "chat_users", "users"
  add_foreign_key "comments", "comments", column: "comment_father_id"
  add_foreign_key "comments", "interactuables"
  add_foreign_key "comments", "users"
  add_foreign_key "favorite_artists", "artists"
  add_foreign_key "favorite_artists", "users"
  add_foreign_key "future_assistances", "events"
  add_foreign_key "future_assistances", "interactuables"
  add_foreign_key "future_assistances", "users"
  add_foreign_key "interactuables", "users"
  add_foreign_key "likes", "interactuables"
  add_foreign_key "likes", "users"
  add_foreign_key "relations", "users", column: "follower_id"
  add_foreign_key "reposts", "interactuables"
  add_foreign_key "reposts", "users"
  add_foreign_key "requests", "users", column: "requester_id"
  add_foreign_key "tagged_users", "interactuables"
  add_foreign_key "tagged_users", "users"
  add_foreign_key "ubications", "countries", on_delete: :cascade
end
