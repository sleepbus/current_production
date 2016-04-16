# == Schema Information
#
# Table name: passengers
#
#  id           :integer          not null, primary key
#  first_name   :string(255)
#  last_name    :string(255)
#  email        :string(255)
#  phone_number :string(255)
#

class Passenger < ActiveRecord::Base
  has_many :tickets

 	def getTrips
  	self.tickets.map {|ticket| Trip.find(ticket.trip_id)}
  end
end
