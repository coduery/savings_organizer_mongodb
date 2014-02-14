module AccountsHelper

  def self.get_accounts(user_id)

    account_names = Array.new
    
    if Account.exists?(user_id)

      user_accounts = Account.where("user_id = ?", user_id)

      user_accounts.each do |account|
        account_names.push(account[:account_name])
      end       

      account_names.sort!

    else
      account_names.push("No Accounts")
    end
  end

  def self.does_account_exist?(user_id, account_name)
    user_accounts = Account.where("user_id = ? AND account_name = ?", 
                                   user_id, account_name)
    user_accounts.size > 0
  end

end
