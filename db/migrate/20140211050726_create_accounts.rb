class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :account_name, :null => false
      t.integer :user_id,     :null => false
      t.timestamps
    end
  end
end
