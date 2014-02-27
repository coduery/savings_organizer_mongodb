class UsersController < ApplicationController

  def login
    if request.get? # display login page
      flash[:alert] = nil
    elsif request.post?
      username = params[:username]
      user = User.find_by user_name: "#{username}"
    if !user.nil? && (UsersHelper.authenticate? user, params)
        flash[:notice] = "Login Successful."
        session[:current_user_id] = user[:id]
        session[:account_name] = AccountsHelper.get_account_names(user[:id]).first
        redirect_to users_welcome_url
      else
        flash[:alert] = "Credentials Invalid. Please try again!"
        session[:current_user_id] = nil
      end
    end
  end

  def registration
  	if request.get? # display registration page
      flash[:alert] = nil
	  elsif request.post?

      user = User.new(:user_name             => params[:user_name],
                      :password              => params[:password],
                      :password_confirmation => params[:password_confirmation],
                      :user_email            => params[:user_email])
    
      if user.valid?
        user.save
        flash[:notice] = "Registration Successful. Please Login!"
        redirect_to root_url
      else
        flash[:alert] = user.errors.first[1]
      end

  	end	
  end

  def welcome
    if request.get? || request.post?
      if !session[:current_user_id].nil?  # display welcome page
        user_id = session[:current_user_id]
        @user_name = UsersHelper.get_user_name(user_id)
        @account_names = AccountsHelper.get_account_names user_id

        if session[:account_name].nil? && request.get?
          account_name = @account_names.first
        elsif request.get?
          account_name = session[:account_name]
        elsif request.post?
          account_name = params[:account_name]
          session[:account_name] = account_name
        end

        @account_total = 
          AccountsHelper.get_account_total(user_id, account_name)
        @number_of_catagories = 
          CategoriesHelper.get_categories(user_id, account_name).size
        @number_of_entries = 
          EntriesHelper.get_number_of_entries(user_id, account_name)
        last_entry = EntriesHelper.get_last_entry(user_id, account_name)
        @last_entry_date = last_entry[0]
        @last_entry_amount = last_entry[1]
      else
        redirect_to users_login_url
      end
    end
  end

end
