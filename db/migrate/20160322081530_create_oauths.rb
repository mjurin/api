class CreateOauths < ActiveRecord::Migration
  def change
    create_table :oauths do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.timestamps null: false
    end
  end
end
