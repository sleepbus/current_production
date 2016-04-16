class Passenger < ActiveRecord::Base
  has_many :tickets

 	def getTrips
  	self.tickets.map {|ticket| Trip.find(ticket.trip_id)}
  end
end
