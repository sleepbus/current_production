# == Schema Information
#
# Table name: trips
#
#  id             :integer          not null, primary key
#  bus_id         :string(255)
#  depart_city_id :integer
#  seats_left     :integer
#  end_city_id    :integer
#  depart_date    :date
#  arrive_date    :date
#  created_at     :datetime
#  updated_at     :datetime
#

class Trip < ActiveRecord::Base
  has_many :tickets
end
