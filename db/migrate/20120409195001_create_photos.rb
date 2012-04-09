class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :service
      t.string :url
      t.string :title
      t.string :image_url
      t.string :thumb_url
      t.string :author_name
      t.string :author_url
      t.integer :width
      t.integer :height
      t.point :location, :geographic => true, :srid => 4326

      t.timestamps
    end

    add_index :photos, :url, :unique => true
    add_index :photos, :location, :spatial => true
  end
end
