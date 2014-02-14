module CategoriesHelper

  def self.is_date_valid?(params)
    !(params[:savings_goal_date]["date_components(1i)"]).blank? &&
    !(params[:savings_goal_date]["date_components(2i)"]).blank? &&
    !(params[:savings_goal_date]["date_components(3i)"]).blank?
  end

  def self.is_goal_entry_valid?(params, date_valid)
    (params[:savings_goal].blank? && !date_valid) ||
    (!params[:savings_goal].blank? && date_valid) ||
    (!params[:savings_goal].blank? && !date_valid)
  end

  def self.does_category_exist?(user_id, account_name, category_name)
    user_accounts = Account.where("user_id = ? AND account_name = ?", 
                                   user_id, account_name)
    if user_accounts.size > 0
      account = user_accounts.first
      account_id = account[:id]
      account_categories = Category.where("account_id = ? AND category_name = ?",
                                          account_id, category_name)
    end

    account_categories.size > 0
  end

end
