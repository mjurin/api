class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :password_digest
      t.string :api_key
      t.string :profile_picture_url
      t.timestamps null: false
    end
  end
end
