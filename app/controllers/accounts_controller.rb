class AccountsController < ApplicationController
  
  def create
    if request.get? 
      if !session[:current_user_id].nil?
        # display create account page
      else
        redirect_to users_login_url
      end
    elsif request.post?
      user_id = session[:current_user_id]
      if AccountsHelper.does_account_exist?(user_id, params[:account_name])
        flash.now[:alert] = "Account Name Already Exists!"
      else
        account = Account.new(:account_name => params[:account_name], 
                              :user_id => user_id)
        if account.valid?
          account.save
          session[:account_name] = params[:account_name]
          flash.now[:notice] = "Account Created Successfully!"
        else
          flash.now[:alert] = account.errors.first[1]
        end
      end
    end
  end

end
