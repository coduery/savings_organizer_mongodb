class CategoriesController < ApplicationController

  def create
    if request.get?

      session[:account_name] = nil
      session[:category_name] = nil
      # TODO: see notes at bottom of file
      # session[:savings_goal_month] = nil
      # session[:savings_goal_day] = nil
      # session[:savings_goal_year] = nil

      if !session[:user].nil?
        user_id = session[:user][:id]
        session[:account_names] = AccountsHelper.get_accounts user_id
        # display create category page
      else
        redirect_to "/users/login"
      end

    elsif request.post?
      user_id = session[:user][:id]
      account = Account.find_by(account_name: params[:account_name], user_id: user_id )
      date_valid = CategoriesHelper.is_date_valid? params
      goal_entry_valid = CategoriesHelper.is_goal_entry_valid?(params, date_valid)

      if !account
        flash.now[:alert] = "Savings account must be created prior to adding a category!"
      elsif CategoriesHelper.does_category_exist?(user_id, params[:account_name], params[:category_name])
        session[:account_name] = params[:account_name]
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
        session[:account_name] = params[:account_name]
        session[:category_name] = params[:category_name]
        # TODO: Ran into session cookie 4KB space limitation when trying to do below. Need to use hidden fields or change session store?
        # session[:savings_goal_month] = params[:savings_goal_date]["date_components(2i)"].to_i
        # session[:savings_goal_day] = params[:savings_goal_date]["date_components(3i)"].to_i
        # session[:savings_goal_year] = params[:savings_goal_date]["date_components(1i)"].to_i
        flash.now[:alert] = "Goal amount required with goal date!"
      end
    end    
  end

end
