class AddOwnerIdToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :owner_id, :integer
    add_index :recipes, :owner_id
  end

  def self.down
    remove_index :recipes, :owner_id
    remove_column :recipes, :owner_id
  end
end
