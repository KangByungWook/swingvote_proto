class CreateUserdata < ActiveRecord::Migration
  def change
    create_table :userdata do |t|
      t.string :username
      t.string :user_id
      #object
      t.string :main_tag
      t.string :tags
      t.string :posts
      t.timestamps null: false
    end
  end
end
