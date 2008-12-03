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

ActiveRecord::Schema.define(:version => 20081202232900) do

  create_table "ingredients", :force => true do |t|
    t.string  "name",         :limit => 40,                               :null => false
    t.decimal "percent",                    :precision => 3, :scale => 6, :null => false
    t.integer "recipe_id",                                                :null => false
    t.integer "subrecipe_id"
  end

  add_index "ingredients", ["recipe_id"], :name => "index_ingredients_on_recipe_id"

  create_table "recipes", :force => true do |t|
    t.string "name", :limit => 40, :null => false
  end

  create_table "units", :force => true do |t|
    t.string "name", :limit => 40, :null => false
    t.string "abbr", :limit => 10, :null => false
    t.string "kind", :limit => 10, :null => false
  end

  add_index "units", ["abbr"], :name => "index_units_on_abbr", :unique => true
  add_index "units", ["name"], :name => "index_units_on_name", :unique => true

end
