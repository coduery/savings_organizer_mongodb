# Class for controlling actions related to "entries" web page views
class EntriesController < ApplicationController

  # Method for handling get and post actions for entries "add" web page
  def add
    if request.get?
      if !session[:current_user_id].nil?
        get_account_category_info
        if @category_names.empty?
          flash.now[:alert] = "No Categories for Savings Account!  Must create at least one category."
        end
      else
        redirect_to users_signin_url
      end
    elsif request.post?
      get_account_category_info
      entry_attributes = entry_params
      if entry_attributes[:account_name] == session[:account_name]
        if !@category_names.empty?
          save_entries = nil
          entries = Array.new

          @category_names.each do |category_name|
            attribute_string = "#{category_name}"
            attribute_symbol = attribute_string.to_sym
            if !entry_attributes[attribute_symbol].blank? && entry_attributes[attribute_symbol] != 0
              category_id = CategoriesHelper.get_category_id(session[:current_user_id], entry_attributes[:account_name], attribute_string)
              entry_date = Date.civil(entry_attributes["entry_date(1i)"].to_i,
                                      entry_attributes["entry_date(2i)"].to_i,
                                      entry_attributes["entry_date(3i)"].to_i)
              entry = Entry.new(:entry_date   => entry_date,
                                :entry_amount => entry_attributes[attribute_symbol],
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
        session[:account_name] = entry_attributes[:account_name]
        redirect_to entries_add_url
      end
    end  
  end

  # Method for handling get and post actions for entries "view" web page
  def view #TODO: can probably cut down on duplication between get and post conditions below
    if request.get?
      if !session[:current_user_id].nil?
        user_id = session[:current_user_id]
        @account_names = AccountsHelper.get_account_names user_id
        @category_names = CategoriesHelper.get_category_names(user_id, session[:account_name])
        @consolidated_entries = EntriesHelper.get_consolidated_entries(user_id, session[:account_name])
      else
        redirect_to users_signin_url
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

    # Method for getting account and category information for user
    def get_account_category_info
      if !session[:current_user_id].nil?
        user_id = session[:current_user_id]
        @account_names = AccountsHelper.get_account_names user_id
        @category_names = CategoriesHelper.get_category_names(user_id, session[:account_name])
      end
    end

    # Method for retrieving entry form data via strong parameters
    def entry_params
      params_allowed = [:account_name, :entry_date]
      @category_names.each do |category_name|
        params_allowed.push(category_name.to_sym)
      end
      params.require(:entry).permit(params_allowed)
    end

end
