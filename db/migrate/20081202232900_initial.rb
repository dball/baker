class Initial < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.column :name, :string, :limit => 40, :null => false
      t.column :abbr, :string, :limit => 10, :null => false
      t.column :kind, :string, :limit => 10, :null => false
    end
    add_index :units, :name, :unique => true
    add_index :units, :abbr, :unique => true

    create_table :recipes do |t|
      t.column :name, :string, :limit => 40, :null => false
    end

    create_table :ingredients do |t|
      t.column :name, :string, :limit => 40, :null => false
      t.column :percent, :decimal, :scale => 6, :precision => 3, :null => false
      t.column :recipe_id, :integer, :null => false
    end

    add_index :ingredients, :recipe_id
  end

  def self.down
    remove_index :ingredients, :recipe_id
    drop_table :ingredients
    drop_table :recipes
    remove_index :units, :abbr
    remove_index :units, :name
    drop_table :units
  end
end
