class Account

  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  
  field :account_name, type: String
  field :user_id,      type: Integer

  belongs_to :user
  has_many :categories

  validates :account_name, 
    presence:   { message: "Account Name is Required!" },
    length:     { maximum: 25, too_long: "Account name too long.
                  Maximum %{count} characters allowed!" }

end
