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

ActiveRecord::Schema[7.0].define(version: 2022_10_26_141245) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "race_id"
  end

  create_table "authentications", id: :serial, force: :cascade do |t|
    t.string "provider", limit: 255
    t.string "uid", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "custom_attributes", limit: 255
    t.integer "user_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "trip_id"
    t.integer "user_id"
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "country_distances", id: :serial, force: :cascade do |t|
    t.integer "distance"
    t.integer "trip_id"
    t.string "country", limit: 255
    t.string "country_code"
  end

  create_table "future_trips", id: :serial, force: :cascade do |t|
    t.string "from", limit: 255
    t.string "to", limit: 255
    t.integer "user_id"
    t.datetime "departure", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "description"
    t.float "from_lng"
    t.float "from_lat"
    t.float "to_lng"
    t.float "to_lat"
    t.string "from_city", limit: 255
    t.string "from_country_code", limit: 255
    t.string "from_country", limit: 255
    t.string "to_city", limit: 255
    t.string "to_country_code", limit: 255
    t.string "to_country", limit: 255
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "occupation", limit: 255
    t.string "mission", limit: 255
    t.string "origin", limit: 255
    t.integer "ride_id"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.integer "trip_id"
    t.string "photo", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "body", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "races", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "from_location", limit: 255
    t.string "to_location", limit: 255
    t.float "from_lat"
    t.float "to_lat"
    t.string "from_address", limit: 255
    t.string "to_address", limit: 255
    t.string "from_country", limit: 255
    t.string "to_country", limit: 255
    t.string "from_city", limit: 255
    t.string "to_city", limit: 255
    t.string "from_postal_code", limit: 255
    t.string "to_postal_code", limit: 255
    t.string "from_formatted_address", limit: 255
    t.string "to_formatted_address", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "rides", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "photo_file_name", limit: 255
    t.string "photo_content_type", limit: 255
    t.string "photo_file_size", limit: 255
    t.string "photo_updated_at", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "story"
    t.integer "waiting_time"
    t.datetime "date", precision: nil
    t.integer "trip_id"
    t.float "duration"
    t.integer "number"
    t.string "experience", limit: 255, default: "good"
    t.string "gender", limit: 255
    t.string "photo_caption", limit: 255
    t.string "photo", limit: 255
    t.string "mission", limit: 255
    t.string "vehicle", limit: 255
    t.string "youtube", limit: 11
    t.index ["experience"], name: "index_rides_on_experience"
    t.index ["gender"], name: "index_rides_on_gender"
    t.index ["number"], name: "index_rides_on_number"
    t.index ["photo_file_name"], name: "index_hitchhikes_on_photo_file_name"
    t.index ["title"], name: "index_rides_on_title"
    t.index ["trip_id"], name: "index_rides_on_trip_id"
    t.index ["vehicle"], name: "index_rides_on_vehicle"
    t.index ["youtube"], name: "index_rides_on_youtube"
  end

  create_table "slugs", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "sluggable_id"
    t.integer "sequence", default: 1, null: false
    t.string "sluggable_type", limit: 40
    t.string "scope", limit: 255
    t.datetime "created_at", precision: nil
    t.index ["name", "sluggable_type", "sequence", "scope"], name: "index_slugs_on_n_s_s_and_s", unique: true
    t.index ["sluggable_id"], name: "index_slugs_on_sluggable_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type", limit: 255
    t.integer "tagger_id"
    t.string "tagger_type", limit: 255
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "trips", id: :serial, force: :cascade do |t|
    t.integer "distance"
    t.datetime "departure", precision: nil
    t.string "from", limit: 255
    t.string "to", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.string "from_country", limit: 255
    t.string "to_country", limit: 255
    t.string "from_city", limit: 255
    t.string "to_city", limit: 255
    t.integer "money_spent"
    t.integer "travelling_with"
    t.datetime "arrival", precision: nil
    t.float "to_lng"
    t.float "to_lat"
    t.float "from_lng"
    t.float "from_lat"
    t.string "from_postal_code", limit: 255
    t.string "from_street", limit: 255
    t.string "from_street_no", limit: 255
    t.string "to_postal_code", limit: 255
    t.string "to_street", limit: 255
    t.string "to_street_no", limit: 255
    t.string "from_formatted_address", limit: 255
    t.string "to_formatted_address", limit: 255
    t.text "route"
    t.integer "google_duration"
    t.string "from_country_code", limit: 255
    t.string "to_country_code", limit: 255
    t.string "from_place_id"
    t.string "to_place_id"
    t.string "from_name"
    t.string "to_name"
    t.index ["from_country"], name: "index_trips_on_from_country"
    t.index ["from_lat"], name: "index_trips_on_from_lat"
    t.index ["from_lng"], name: "index_trips_on_from_lng"
    t.index ["to_country"], name: "index_trips_on_to_country"
    t.index ["travelling_with"], name: "index_trips_on_travelling_with"
    t.index ["user_id"], name: "index_trips_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "password_salt", limit: 255
    t.string "reset_password_token", limit: 255
    t.string "remember_token", limit: 255
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "username", limit: 255
    t.boolean "admin", default: false
    t.string "gender", limit: 255
    t.float "lat"
    t.float "lng"
    t.text "about_you"
    t.string "cs_user", limit: 255
    t.string "city", limit: 255
    t.string "country_code", limit: 255
    t.string "country", limit: 255
    t.string "formatted_address", limit: 255
    t.datetime "location_updated_at", precision: nil
    t.date "date_of_birth"
    t.string "languages", limit: 255
    t.string "origin", limit: 255
    t.string "be_welcome_user", limit: 255
    t.datetime "reset_password_sent_at", precision: nil
    t.string "uid", limit: 255
    t.string "provider", limit: 255
    t.string "oauth_token", limit: 255
    t.time "oauth_expires_at"
    t.string "name", limit: 255
    t.string "trustroots"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["country"], name: "index_users_on_country"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["formatted_address"], name: "index_users_on_formatted_address"
    t.index ["gender"], name: "index_users_on_gender"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username"
  end

end
