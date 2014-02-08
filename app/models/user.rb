class User < ActiveRecord::Base

  attr_accessor :message

  validates :user_name, presence: 
    { message: "Username not valid. Please try again!" }
  validates :password, confirmation: 
    { message: "Passwords entries must be identical. Please try again!" }
  validates :password_confirmation, presence: 
    { message: "Password entry is not valid. Please try again!" }
  validates :user_email, presence: 
    { message: "Email addess not valid. Please try again!" }


  def authenticate?(user, attributes)

    if user[:password] == attributes[:password]
      @message = "Login Successful."
    end

    user[:password] == attributes[:password]

  end

end
