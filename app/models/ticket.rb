# == Schema Information
#
# Table name: tickets
#
#  id           :integer          not null, primary key
#  passenger_id :integer
#  trip_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Ticket < ActiveRecord::Base
  belongs_to :passenger
  belongs_to :trip

  after_validation :decrement_seats_left

  def decrement_seats_left
  	Trip.find(self.trip_id).decrement!(:seats_left) #need some sort of catch here but not sure yet the errors we need to be looking for
  end

  def send_confirmation_email
    s = erb :ticket_confirmation_email
    if passenger.email.present?
      Pony.mail(
        to: passenger.email,
        from: "SleepBus <no-reply@sleepbus.co>",
        subject: "SleepBus Confirmation ##{(id + 1000)}",
        html_body:
          "<p>Thank you so much for purchasing a SleepBus Ticket!</p>" +
          "<p>This message is to confirm your upcoming trip on SleepBus.</p>" +
          "<p>Passenger name: #{passenger.first_name} #{passenger.last_name}</p>" +
          "<p>"
      )
    end
  end
end
