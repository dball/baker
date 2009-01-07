# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090107230831) do

  create_table "ingredients", :force => true do |t|
    t.decimal "percent",                    :precision => 6, :scale => 3, :null => false
    t.integer "recipe_id",                                                :null => false
    t.string  "name",         :limit => 40
    t.integer "subrecipe_id"
  end

  add_index "ingredients", ["recipe_id"], :name => "index_ingredients_on_recipe_id"

  create_table "recipes", :force => true do |t|
    t.string  "name",        :limit => 40, :null => false
    t.string  "base_weight", :limit => 20
    t.text    "preparation"
    t.string  "source"
    t.integer "source_page"
    t.integer "owner_id"
  end

  add_index "recipes", ["name"], :name => "index_recipes_on_name"
  add_index "recipes", ["owner_id"], :name => "index_recipes_on_owner_id"

  create_table "users", :force => true do |t|
    t.string   "login",                                :null => false
    t.string   "crypted_password",                     :null => false
    t.string   "password_salt",                        :null => false
    t.string   "persistence_token",                    :null => false
    t.integer  "login_count",       :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",             :default => false, :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
