class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :email, :null => false
      t.string :password_digest

      t.timestamps
    end

    add_index :accounts, [:email]
  end
end
