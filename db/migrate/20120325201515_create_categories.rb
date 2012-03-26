class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :ancestry
      t.string :table
      t.string :type

      t.string :name, :null => false
      t.text :description

      t.string :icon

      t.string :keywords

      t.timestamps
    end

    add_index :categories, :ancestry
    add_index :categories, :name, :unique => true
    add_index :categories, [:table, :type], :unique => true
  end
end
