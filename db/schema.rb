# -*- encoding : utf-8 -*-
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

ActiveRecord::Schema.define(:version => 20120419173445) do

  create_table "banners", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "img_banner"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "desccat"
    t.string   "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filters"
    t.string   "search_title"
  end

  create_table "filters", :force => true do |t|
    t.string   "name"
    t.text     "values"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "main_flag"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "userto_id"
    t.string   "name"
    t.string   "phone"
    t.string   "date"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "suborder_id"
    t.integer  "status"
    t.string   "total"
    t.string   "email"
    t.string   "address"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "keywords"
    t.string   "descpage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "search_title"
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.string   "brand"
    t.string   "value_type"
    t.string   "value_price"
    t.integer  "user_id"
    t.integer  "category_id"
    t.string   "img_product"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filters"
    t.string   "discount"
    t.integer  "status"
  end

  create_table "sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suborders", :force => true do |t|
    t.integer  "user_id"
    t.string   "uriks"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "enc_pass"
    t.string   "role"
    t.string   "bday"
    t.string   "company_name"
    t.string   "contact_fio"
    t.string   "phone"
    t.string   "img"
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "minimal_price"
  end

end
