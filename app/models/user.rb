class User < ActiveRecord::Base

  has_many :accounts

  validates :user_name, 
    presence:   { message: "Username not valid. Please try again!" },
    uniqueness: { message: "Username already taken. Please try another!" },
    length:     { maximum: 20, too_long: "Username too long.  
                                      Maximum %{count} characters allowed!" }
  validates :password, 
    confirmation: { message: "Passwords entries must be identical. Please try again!" }

  validates :password_confirmation, 
    presence: { message: "Password entry is not valid. Please try again!" },
    length:   { maximum: 20, too_long: "Password too long.  
                                      Maximum %{count} characters allowed!" }
  validates :user_email, 
    presence: { message: "Email addess not valid. Please try again!" },
    length:   { maximum: 40, too_long: "Email too long.  
                                      Maximum %{count} characters allowed!" }


  def authenticate?(user, attributes)
    user[:password] == attributes[:password]
  end

end
