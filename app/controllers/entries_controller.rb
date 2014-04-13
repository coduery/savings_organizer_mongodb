# Class for controlling actions related to "entries" web page views
class EntriesController < ApplicationController

  # Method for handling get and post actions for entries "add" web page
  def add
    if request.get?
      if !session[:current_user_id].nil?
        get_account_category_info
        if @account_names.nil?
          flash_no_account_alert
        elsif @category_names.empty?
          flash_no_category_alert
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
            if !entry_attributes[attribute_symbol].blank? && entry_attributes[attribute_symbol].to_i > 0
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
                flash[:alert] = entry.errors.first[1]
                break;
              end
            end
          end

          if !save_entries.nil?
            entries.each do |entry|
              entry.save
            end
            flash[:notice] = "Entries Added Successfully!"
          elsif flash[:alert].nil?
            flash[:alert] = "Entry must be greater than zero!"
          end
        end
      else 
        session[:account_name] = entry_attributes[:account_name]
      end
      redirect_to entries_add_url
    end  
  end
  
  # Method for handling get and post actions for entries "deduct" web page
  def deduct
    deduct_request_get request if request.get?
    deduct_request_post request if request.post?
  end

  # Method for handling get and post actions for entries "view" web page
  def view #TODO: can probably cut down on duplication between get and post conditions below
    if request.get?
      if !session[:current_user_id].nil?
        user_id = session[:current_user_id]
        @account_names = AccountsHelper.get_account_names user_id
        @category_names = CategoriesHelper.get_category_names(user_id, session[:account_name])
        if @account_names.nil?
          flash_no_account_alert
        elsif @category_names.empty?
          flash_no_category_alert
        else
          @consolidated_entries = EntriesHelper.get_consolidated_entries(user_id, session[:account_name])
          if @consolidated_entries.empty?
            flash.now[:alert] = "No Entries have been added to account categories!"
          else
            @account_total = AccountsHelper.get_account_total(user_id, session[:account_name])
          end
        end
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
        if @category_names.empty?
          flash_no_category_alert
        else
          @consolidated_entries = EntriesHelper.get_consolidated_entries(user_id, session[:account_name])
        end
        redirect_to entries_view_url
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
    
    # Method for getting the dollar balance for a savings account category
    def get_category_balance(category_name)
      category_id = CategoriesHelper.get_category_id(session[:current_user_id],
                    session[:account_name], category_name)
      @category_balance = CategoriesHelper.get_category_entries_total category_id
    end

    # Method for retrieving entry form data via strong parameters
    def entry_params
      params_allowed = [:account_name, :entry_date, :category_name, :entry_amount]
      if !@category_names.nil?
        @category_names.each do |category_name|
          params_allowed.push(category_name.to_sym)
        end
      end
      params.require(:entry).permit(params_allowed)
    end
    
    # Method for handling "deduct" web page get requests
    def deduct_request_get(request)
      if !session[:current_user_id].nil?
        get_account_category_info
        if @account_names.nil?
          flash_no_account_alert
        elsif @category_names.empty?
          flash_no_category_alert
        else
           if session[:category_name].nil?
             session[:category_name] = @category_names.first
           end
           get_category_balance session[:category_name]
        end
      else
        redirect_to users_signin_url
      end
    end

    # Method for handling "deduct" web page post requests    
    def deduct_request_post(request)
      get_account_category_info
      get_category_balance session[:category_name]
      entry_attributes = entry_params
      if session[:account_name] == entry_attributes[:account_name] && 
         session[:category_name] == entry_attributes[:category_name]
        if !@category_names.empty? && entry_attributes[:entry_amount].to_f <= @category_balance
            if !entry_attributes[:entry_amount].blank? && entry_attributes[:entry_amount].to_i > 0
              category_id = CategoriesHelper.get_category_id(session[:current_user_id], 
                            entry_attributes[:account_name], entry_attributes[:category_name])
              entry_date = Date.civil(entry_attributes["entry_date(1i)"].to_i,
                                      entry_attributes["entry_date(2i)"].to_i,
                                      entry_attributes["entry_date(3i)"].to_i)
              entry = Entry.new(:entry_date   => entry_date,
                                :entry_amount => "-" + entry_attributes[:entry_amount],
                                :category_id  => category_id)
            end
          if !entry.nil?
            entry.save
            get_category_balance session[:category_name]
            flash[:notice] = "Entry Deducted Successfully!"
          elsif flash[:alert].nil?
            flash[:alert] = "Deduction amount cannot be blank and must be positive!"
          end
        elsif entry_attributes[:entry_amount].to_f > @category_balance
          flash[:alert] = "Invalid deduction amount.  Amount exceeds category balance!"
        end
      elsif session[:account_name] == entry_attributes[:account_name]
        session[:category_name] = entry_attributes[:category_name]
        get_category_balance session[:category_name]
        get_account_category_info
      else
        session[:account_name] = entry_attributes[:account_name]
        get_account_category_info
        if @category_names.empty?
          flash_no_category_alert
        else
          session[:category_name] = @category_names.first
          get_category_balance session[:category_name]
        end
      end
      redirect_to entries_deduct_url
    end
    
    def flash_no_account_alert
      flash.now[:alert] = "No Accounts for User.  Must create at least one account!"
    end
    
    def flash_no_category_alert
      flash.now[:alert] = "No Categories for Savings Account.  Must create at least one category!"
    end

end
