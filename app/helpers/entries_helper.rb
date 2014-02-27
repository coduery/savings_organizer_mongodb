module EntriesHelper

  def self.get_number_of_entries(user_id, account_name)
    account_categories = CategoriesHelper.get_categories(user_id, account_name)
    number_of_entries = 0
    account_categories.each do |category|
      number_of_entries += CategoriesHelper.get_number_of_entries(category[:id])
    end
    number_of_entries
  end

  def self.get_last_entry(user_id, account_name)
    category_entries = get_entries(user_id, account_name)
    if !category_entries.empty?
      last_entry_date = category_entries.first[:entry_date]
      last_created_date = category_entries.first[:created_at].to_i
      last_entry_amount = 0
      category_entries.each do |entry|
        if entry[:entry_date] == last_entry_date && (entry[:created_at].to_i == last_created_date || entry[:created_at].to_i == last_created_date - 1)
          last_entry_amount += entry[:entry_amount]
        else
          break;
        end
      end
      last_entry_date = last_entry_date.strftime("%B %-d, %Y")
    else
      last_entry_date = "No Entries"
      last_entry_amount = 0
    end
    [ last_entry_date, last_entry_amount ]
  end

  def self.get_entries(user_id, account_name)
    account_categories = CategoriesHelper.get_categories(user_id, account_name)
    category_ids = Array.new
    account_categories.each do |category|
      category_ids.push(category[:id])
    end
    category_entries = Entry.where("category_id IN (?)" , category_ids).order("entry_date DESC, created_at DESC")



    category_entries_date_set = Array.new
    category_entries_resorted = Array.new

    category_name_id_mapping = get_category_name_id_mapping(user_id, account_name).sort

    for i in 0..(category_entries.size - 1)
      category_entries_date_set.push(category_entries[i])
      if i < category_entries.size - 1 && category_entries[i + 1][:entry_date] == category_entries[i][:entry_date] && 
        (category_entries[i + 1][:created_at].to_i == category_entries[i][:created_at].to_i ||
         category_entries[i + 1][:created_at].to_i == category_entries[i][:created_at].to_i + 1 ||
         category_entries[i + 1][:created_at].to_i == category_entries[i][:created_at].to_i - 1)
        next
      else
        
        # print "\n\n#{category_entries_date_set.inspect}\n\n"

        for j in 0..(account_categories.size - 1)

          

          category_entries_date_set.each do |entry|

            if entry[:category_id] == category_name_id_mapping[j][1]

              category_entries_resorted.push(entry)
            end
          end

        end

        category_entries_date_set = Array.new

        # print "\n\n#{category_entries_resorted.inspect}\n\n"



      end
    end

    # print "\n\n"
    # print category_entries.all.inspect
    # print "\n\n"

    # print category_entries_resorted.inspect
    # print "\n\n"

    #category_entries
    category_entries_resorted
  end

  def self.get_category_name_id_mapping(user_id, account_name)
    account_categories = CategoriesHelper.get_categories(user_id, account_name)
    category_name_id_map = {}
    account_categories.each do |category|
      category_name_id_map[category[:category_name]] = category[:id]
    end
    category_name_id_map
  end

end
