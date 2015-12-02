class CreateMobileusers < ActiveRecord::Migration
  def change
    create_table :mobileusers do |t|

      t.timestamps null: false
    end
  end
end
