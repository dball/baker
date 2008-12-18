class Initial < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.column :name, :string, :limit => 40, :null => false
      t.column :base_weight, :string, :limit => 20
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
  end
end
