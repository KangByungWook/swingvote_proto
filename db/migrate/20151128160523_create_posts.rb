class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :subject
      t.string :img_url
      #object
      t.string :left
      t.string :right
      
      t.string :main_tag
      
      #array
      t.string :tags
      t.string :links
      
      t.timestamps null: false
    end
  end
end
