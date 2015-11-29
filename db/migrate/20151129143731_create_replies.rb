class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.string :user_id
      t.string :post_id
      t.boolean :pro_or_cons
      t.string :content
      
      t.timestamps null: false
    end
  end
end
