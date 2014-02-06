class User < ActiveRecord::Base

  attr_accessor :message


  def is_valid?(attributes)

    new_username = attributes[:new_username]
    new_password = attributes[:new_password]
    new_password_confirm = attributes[:new_password_confirm]
    email_address = attributes[:email_address]

    if !is_username_valid? new_username
      @message = "Username not valid. Please try again!"
      nil
    elsif !are_passwords_equal? new_password, new_password_confirm
      @message = "Passwords entries must be identical. Please try again!"
      nil
    elsif !is_password_valid? new_password
      @message = "Password entry is not valid. Please try again!"
      nil      
    elsif !is_email_valid? email_address
      @message = "Email addess not valid. Please try again!"
      nil
    else
      @message = "Registration Successful. Please Login!"
      !nil      
    end

  end


  def authenticate?(user, attributes)

    if user[:password] == attributes[:password]
      @message = "Login Successful."
    end

    user[:password] == attributes[:password]

  end


  private

  def is_username_valid?(new_username)
    !new_username.blank?
  end

  def are_passwords_equal?(new_password, new_password_confirm)
    new_password.eql? new_password_confirm
  end

  def is_password_valid?(new_password)
    !new_password.blank?
  end

  def is_email_valid?(email_address)
    !email_address.blank?
  end

end
