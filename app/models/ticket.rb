# == Schema Information
#
# Table name: tickets
#
#  id           :integer          not null, primary key
#  passenger_id :integer
#  trip_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  refunded     :boolean          default(FALSE)
#

class Ticket < ActiveRecord::Base
  belongs_to :passenger
  belongs_to :trip

  after_validation :decrement_seats_left

  def decrement_seats_left
  	Trip.find(self.trip_id).decrement!(:seats_left) #need some sort of catch here but not sure yet the errors we need to be looking for
  end
end
