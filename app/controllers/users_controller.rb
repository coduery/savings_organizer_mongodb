class UsersController < ApplicationController

  def login
    if request.get? # display login page
      flash[:alert] = nil
    elsif request.post?
      username = params[:username]
      user = User.find_by user_name: "#{username}"
      if !user.nil? && (user.authenticate? user, params)
        flash[:notice] = "#{user.message}"
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

      user = User.new(:user_name  => params[:new_username],
                      :password   => params[:new_password],
                      :user_email => params[:email_address])

      if user.is_valid?(params)       
        user.save
        flash[:notice] = "#{user.message}"
        redirect_to root_url
      else
        flash[:alert] = "#{user.message}"
      end

  	end	
  end

  def welcome
    if !session[:user].nil?
      # display welcome page
    else
      redirect_to "/users/login"
    end
  end

end
