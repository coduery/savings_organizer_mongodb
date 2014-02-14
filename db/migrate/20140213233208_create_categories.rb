class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category_name, :null => false
      t.float :savings_goal
      t.date :savings_goal_date
      t.integer :account_id,   :null => false
      t.timestamps
    end
  end
end
