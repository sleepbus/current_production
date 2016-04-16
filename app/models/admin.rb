# == Schema Information
#
# Table name: admins
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  password_hash :string(255)
#

class Admin < ActiveRecord::Base
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(password)
    self.password == password
  end
end
