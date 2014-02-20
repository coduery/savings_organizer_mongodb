module UsersHelper

  def self.authenticate?(user, attributes)
    user[:password] == attributes[:password]
  end

  def self.get_user_name(id)
    User.where("id = ?", id).first[:user_name]
  end

end
