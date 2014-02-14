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
      session[:account_names] = AccountsHelper.get_accounts user_id
      # display welcome page
    else
      redirect_to "/users/login"
    end
  end

end
