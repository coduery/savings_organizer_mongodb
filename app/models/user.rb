class User
  
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  include ActiveModel::SecurePassword
  
  field :user_name,       type: String
  field :password_digest, type: String
  field :user_email,      type: String  

  before_save do
    self.user_name = user_name.downcase
    self.user_email = user_email.downcase
  end

  has_many :accounts # can add dependent: :destroy to automatically delete accounts when user is destroyed

  validates :user_name, 
    presence:   { message: "Username not valid. Please try again!" },
    uniqueness: { case_sensitive: false, 
                  message: "Username already taken. Please try another!" },
    length:     { maximum: 20, too_long: "Username too long.  
                                      Maximum %{count} characters allowed!" }

  has_secure_password

  validates :password,
    length: { minimum: 6, too_short: "Password too short.  
                                      Minimum %{count} characters required!",
              maximum: 20, too_long: "Password too long.  
                                      Maximum %{count} characters allowed!" }
  
  EMAIL_REGEX_VALIDATION_PATTERN = /\A[\w+\-.]+@[a-z\d\-]+\.[a-z]+\z/i

  validates :user_email, 
    presence: { message: "Email addess not valid. Please try again!" },
    length:   { maximum: 40, too_long: "Email too long.  
                                      Maximum %{count} characters allowed!" },
    format:   { with: EMAIL_REGEX_VALIDATION_PATTERN, message: "Invalid email address" }

end
