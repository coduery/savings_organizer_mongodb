class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.date :entry_date,     :null => false
      t.float :entry_amount,  :null => false
      t.integer :category_id, :null => false
      t.timestamps
    end
  end
end
