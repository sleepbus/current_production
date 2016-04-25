# == Schema Information
#
# Table name: fake_tickets
#
#  id                    :integer          not null, primary key
#  passenger_id          :integer
#  depart_city_id        :integer
#  return_depart_city_id :integer
#  depart_date           :date
#  return_depart_date    :date
#

class FakeTicket < ActiveRecord::Base
  belongs_to :fake_passenger
  belongs_to :depart_city, class_name: 'City', foreign_key: :depart_city_id
  validates_uniqueness_of :fake_passenger_id, scope: [ :depart_city_id, :depart_date ]
end
