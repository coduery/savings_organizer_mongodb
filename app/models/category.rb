class Category

  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :category_name,     type: String
  field :savings_goal,      type: Float 
  field :savings_goal_date, type: Date 
  field :account_id,        type: Integer

  belongs_to :account
  has_many :entries

  validates :category_name, 
    presence: { message: "Category Name is Required!" },
    length:   { maximum: 25, too_long: "Category name too long.  
                Maximum %{count} characters allowed!" }

  validates :savings_goal, allow_blank: true, numericality: { greater_than: 0, 
    message: "Invalid dollar amount! Dollar amount must be greater than zero!" }

  validates :account_id, presence: true

end
