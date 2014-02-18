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
    account_id = AccountsHelper.get_account_id(user_id, account_name)

    if !account_id.nil?
      account_categories = Category.where("account_id = ? AND category_name = ?",
                                          account_id, category_name)
    else
      account_categories = []
    end

    !account_categories.empty?
  end

  def self.get_categories(user_id, account_name)
    account_id = AccountsHelper.get_account_id(user_id, account_name)

    if !account_id.nil?
      account_categories = Category.where("account_id = ?", account_id)
    else
      account_categories = []
    end
  end

end
