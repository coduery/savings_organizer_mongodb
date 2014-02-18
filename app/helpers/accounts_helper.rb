module AccountsHelper

  def self.get_account_id(user_id, account_name)
    user_accounts = Account.where("user_id = ? AND account_name = ?", 
                                   user_id, account_name)
    if !user_accounts.empty?
      account = user_accounts.first
      account_id = account[:id]
    else
      account_id = nil
    end
  end

  def self.get_account_names(user_id)

    account_names = Array.new
    user_accounts = Account.where("user_id = ?", user_id)

    if !user_accounts.empty?
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
    !user_accounts.empty?
  end

end
