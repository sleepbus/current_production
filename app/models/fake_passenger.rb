# == Schema Information
#
# Table name: fake_passengers
#
#  id           :integer          not null, primary key
#  first_name   :string(255)
#  last_name    :string(255)
#  email        :string(255)
#  phone_number :string(255)
#

class FakePassenger < ActiveRecord::Base
  has_many :fake_tickets
end
