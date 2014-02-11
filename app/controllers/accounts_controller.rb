class AccountsController < ApplicationController
  
  def create
    if request.get? 
      # display create account page
    elsif request.post?
      user_id = session[:user][:id]
      account = Account.new(:account_name => params[:account_name], 
                            :user_id => user_id)
      if account.valid?
        account.save
        flash.now[:notice] = "Account Created Successfully!"
      else
        flash.now[:alert] = account.errors.first[1]
      end
    end
  end

end
