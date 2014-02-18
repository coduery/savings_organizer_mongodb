class UsersController < ApplicationController

  def login
    if request.get? # display login page
      flash[:alert] = nil
    elsif request.post?
      username = params[:username]
      user = User.find_by user_name: "#{username}"
      if !user.nil? && (user.authenticate? user, params)
        flash[:notice] = "Login Successful."
        session[:user] = user
        redirect_to "/users/welcome"
      else
        flash[:alert] = "Credentials Invalid. Please try again!"
        session[:user] = nil
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
    if !session[:user].nil?
      user_id = session[:user][:id]
      account_names = AccountsHelper.get_account_names user_id
      account_name = account_names.first
      number_of_catagories = CategoriesHelper.get_categories(user_id, account_name).size
      session[:account_names] = account_names
      session[:number_of_catagories] = number_of_catagories
      # display welcome page
    else
      redirect_to "/users/login"
    end
  end

end
