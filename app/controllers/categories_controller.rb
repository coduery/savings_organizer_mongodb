class CategoriesController < ApplicationController

  attr_reader :account_names, :category_name, 
              :savings_goal_month, :savings_goal_day, :savings_goal_year

  def create
    if request.get?

      if !session[:current_user_id].nil? # display create category page
        user_id = session[:current_user_id]
        @account_names = AccountsHelper.get_account_names user_id
        @category_name = nil
      else
        redirect_to users_signin_url
      end

    elsif request.post?
      user_id = session[:current_user_id]
      @account_names = AccountsHelper.get_account_names user_id
      account = Account.find_by(account_name: params[:account_name], user_id: user_id )
      date_valid = CategoriesHelper.is_date_valid? params
      goal_entry_valid = CategoriesHelper.is_goal_entry_valid?(params, date_valid)

      if !account
        flash.now[:alert] = "Savings account must be created prior to adding a category!"
      elsif CategoriesHelper.does_category_exist?(user_id, params[:account_name], params[:category_name])
        flash.now[:alert] = "Category Name Already Exists!"
      elsif goal_entry_valid

        if date_valid
          savings_goal_date = Date.civil(params[:savings_goal_date]["date_components(1i)"].to_i,
                                         params[:savings_goal_date]["date_components(2i)"].to_i,
                                         params[:savings_goal_date]["date_components(3i)"].to_i)
        end

        category = Category.new(:category_name     => params[:category_name], 
                                :savings_goal      => params[:savings_goal],
                                :savings_goal_date => savings_goal_date,
                                :account_id        => account[:id])

        if category.valid?
          category.save
          flash.now[:notice] = "Category Created Successfully!"
        else
          flash.now[:alert] = category.errors.first[1]
        end

      elsif date_valid
        @category_name = params[:category_name]
        flash.now[:alert] = "Goal amount required with goal date!"
      end

      session[:account_name] = params[:account_name]
    end    
  end

end
