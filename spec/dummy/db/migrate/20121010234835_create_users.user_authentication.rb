# This migration comes from user_authentication (originally 20121009010000)
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :null => false
      t.string :password_digest

      t.timestamps
    end

    add_index :users, [:email]
  end
end
