class Initial < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.column :name, :string, :limit => 40, :null => false
      t.column :abbr, :string, :limit => 10, :null => false
      t.column :kind, :string, :limit => 10, :null => false
      t.column :family, :string, :limit => 10, :null => false
      t.column :scale, :decimal, :scale => 4, :precision => 9, :null => false
    end
    add_index :units, [:name, :family], :unique => true
    add_index :units, [:abbr, :family], :unique => true

    create_table :recipes do |t|
      t.column :name, :string, :limit => 40, :null => false
      t.column :default_unit_scale, :decimal, :scale => 2, :precision => 5
      t.column :preparation, :text
      t.column :source, :string
      t.column :source_page, :integer
    end
    add_index :recipes, :name

    create_table :ingredients do |t|
      t.column :percent, :decimal, :scale => 3, :precision => 6, :null => false
      t.column :recipe_id, :integer, :null => false
      t.column :name, :string, :limit => 40
      t.column :subrecipe_id, :integer
    end

    add_index :ingredients, :recipe_id
  end

  def self.down
    remove_index :ingredients, :recipe_id
    drop_table :ingredients
    remove_index :recipes, :name
    drop_table :recipes
    remove_index :units, [:abbr, :family]
    remove_index :units, [:name, :family]
    drop_table :units
  end
end
