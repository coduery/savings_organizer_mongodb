class Entry < ActiveRecord::Base

  belongs_to :category

  validates :entry_amount, numericality: { greater_than: 0, message: 
    "Invalid dollar amount! Dollar amount must be greater than zero!" }

end
