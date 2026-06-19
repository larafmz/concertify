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

ActiveRecord::Schema[7.2].define(version: 2026_06_19_175613) do
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
    t.index ["genre_id"], name: "index_artists_on_genre_id"
  end

  create_table "artists_concerts", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "concert_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id", "concert_id"], name: "index_artists_concerts_on_artist_id_and_concert_id", unique: true
    t.index ["artist_id"], name: "index_artists_concerts_on_artist_id"
    t.index ["concert_id"], name: "index_artists_concerts_on_concert_id"
  end

  create_table "concerts", force: :cascade do |t|
    t.string "ticketmaster_id"
    t.string "tour_name"
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ubication_id"
    t.index ["ubication_id"], name: "index_concerts_on_ubication_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "future_assistances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "concert_id", null: false
    t.boolean "alone"
    t.string "from"
    t.integer "concert_seat"
    t.string "concert_seat_details"
    t.bigint "interactuable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concert_id"], name: "index_future_assistances_on_concert_id"
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
    t.string "text"
    t.bigint "artist_id"
    t.bigint "concert_id"
    t.integer "puntuation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_interactuables_on_artist_id"
    t.index ["concert_id"], name: "index_interactuables_on_concert_id"
    t.index ["user_id"], name: "index_interactuables_on_user_id"
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
    t.string "address"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_ubications_on_country_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "artists_concerts", "artists"
  add_foreign_key "artists_concerts", "concerts"
  add_foreign_key "future_assistances", "concerts"
  add_foreign_key "future_assistances", "interactuables"
  add_foreign_key "future_assistances", "users"
  add_foreign_key "interactuables", "users"
  add_foreign_key "tagged_users", "interactuables"
  add_foreign_key "tagged_users", "users"
  add_foreign_key "ubications", "countries", on_delete: :cascade
end
