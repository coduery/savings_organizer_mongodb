class EntriesController < ApplicationController

  attr_reader :account_names, :category_names

  def add
    if request.get? # display add entry page

      if !session[:current_user_id].nil?
        set_account_category_info
        if @category_names.empty?
          flash.now[:alert] = "No Categories for Savings Account!  Must create at least one category."
        end
      else
        redirect_to users_login_url
      end

    elsif request.post?
      if params[:account_name] == session[:account_name]
        set_account_category_info
        if !@category_names.empty?
          save_entries = nil
          entries = Array.new

          @category_names.each do |category_name|
            param_string = "#{category_name}"
            param_symbol = param_string.to_sym
            if !params[param_symbol].blank? && params[param_symbol] != 0
              category_id = CategoriesHelper.get_category_id(session[:current_user_id], params[:account_name], param_string)
              entry_date = Date.civil(params[:entry_date]["date_components(1i)"].to_i,
                                      params[:entry_date]["date_components(2i)"].to_i,
                                      params[:entry_date]["date_components(3i)"].to_i)
              entry = Entry.new(:entry_date   => entry_date,
                                :entry_amount => params[param_symbol],
                                :category_id  => category_id)
              if entry.valid?
                entries.push(entry)
                save_entries = !nil
              else
                save_entries = nil
                flash.now[:alert] = entry.errors.first[1]
                break;
              end
            end
          end

          if !save_entries.nil?
            entries.each do |entry|
              entry.save
            end
            flash.now[:notice] = "Entries Added Successfully!"
          elsif flash.now[:alert].nil?
            flash.now[:alert] = "Entries cannot all be blank!"
          end
        end
      else 
        session[:account_name] = params[:account_name]
        redirect_to entries_add_url
      end
    end  
  end

  def view #TODO: can probably cut down on duplication between get and post conditions below
    if request.get?
      if !session[:current_user_id].nil?
        user_id = session[:current_user_id]
        @account_names = AccountsHelper.get_account_names user_id
        @category_names = CategoriesHelper.get_category_names(user_id, session[:account_name])
        @consolidated_entries = EntriesHelper.get_consolidated_entries(user_id, session[:account_name])
      else
        redirect_to users_login_url
      end
    elsif request.post?
      if !session[:current_user_id].nil?
        user_id = session[:current_user_id]
        account_name = params[:account_name]
        session[:account_name] = account_name
        @account_names = AccountsHelper.get_account_names user_id
        @category_names = CategoriesHelper.get_category_names(user_id, session[:account_name])
        @consolidated_entries = EntriesHelper.get_consolidated_entries(user_id, session[:account_name])
      end
    end
  end

  private

  def set_account_category_info
    if !session[:current_user_id].nil?
      user_id = session[:current_user_id]
      @account_names = AccountsHelper.get_account_names user_id
      @category_names = CategoriesHelper.get_category_names(user_id, session[:account_name])
    end
  end

end
