class Account < ActiveRecord::Base

  belongs_to :user

  validates :account_name, 
    presence:   { message: "Account Name is Required!" },
    uniqueness: { message: "Account Name Already Exists!" },
    length:     { maximum: 30, too_long: "Account name too long.  
                                      Maximum %{count} characters allowed!" }

end
