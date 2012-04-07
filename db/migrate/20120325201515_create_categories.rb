class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.string :ancestry
      t.string :table
      t.string_array :types

      t.string :name, :null => false
      t.text :description

      t.string :icon

      t.string :keywords
      t.string :default_object_name

      t.timestamps
    end

    add_index :categories, :ancestry
    add_index :categories, :name, :unique => true

    execute "CREATE INDEX ON categories USING GIN(types)"
  end

  def down
    drop_table :categories
  end
end
