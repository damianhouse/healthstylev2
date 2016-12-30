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

ActiveRecord::Schema.define(version: 20161229233301) do

  create_table "conversations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "coach_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id"], name: "index_conversations_on_coach_id"
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "read",            default: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "coach_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id"], name: "index_notes_on_coach_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "stripe_webhooks", force: :cascade do |t|
    t.string   "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "avatar"
    t.boolean  "approved",               default: false
    t.boolean  "is_coach",               default: false
    t.boolean  "is_admin",               default: false
    t.integer  "primary_coach"
    t.text     "greeting"
    t.text     "philosophy"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.text     "secondary_users"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.datetime "avatar_updated_at"
    t.integer  "avatar_file_size"
    t.integer  "secondary_coach"
    t.integer  "tertiary_coach"
    t.string   "stripe_id"
    t.datetime "expires_at"
    t.string   "status"
    t.boolean  "terms_read",             default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["secondary_coach"], name: "index_users_on_secondary_coach"
    t.index ["stripe_id"], name: "index_users_on_stripe_id"
    t.index ["tertiary_coach"], name: "index_users_on_tertiary_coach"
  end

end
