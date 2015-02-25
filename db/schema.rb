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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150225200440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banners", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "url",         limit: 255
    t.string   "img_banner",  limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "description"
    t.string   "desccat",      limit: 255
    t.string   "keywords",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filters",      limit: 255
    t.string   "search_title", limit: 255
  end

  create_table "filters", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "values"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "main_flag"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "userto_id"
    t.string   "name",        limit: 255
    t.string   "phone",       limit: 255
    t.string   "date",        limit: 255
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "suborder_id"
    t.integer  "status"
    t.string   "total",       limit: 255
    t.string   "email",       limit: 255
    t.string   "address",     limit: 255
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.text     "description"
    t.string   "keywords",     limit: 255
    t.string   "descpage",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "search_title", limit: 255
  end

  create_table "products", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "brand",       limit: 255
    t.string   "value_type",  limit: 255
    t.string   "value_price", limit: 255
    t.integer  "user_id"
    t.integer  "category_id"
    t.string   "img_product", limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filters",     limit: 255
    t.string   "discount",    limit: 255
    t.integer  "status"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suborders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "uriks",      limit: 255
    t.string   "status",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.string   "name",                   limit: 255
    t.string   "enc_pass",               limit: 255
    t.string   "role",                   limit: 255
    t.string   "bday",                   limit: 255
    t.string   "company_name",           limit: 255
    t.string   "contact_fio",            limit: 255
    t.string   "phone",                  limit: 255
    t.string   "img",                    limit: 255
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "minimal_price",          limit: 255
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
