post "/stripe/charge" do
  begin
      customer = Stripe::Customer.create(
        :email => params["stripeEmail"],
        :card  => params[:stripeToken]
      )
    rescue Stripe::InvalidRequestError => e
      # return e
    rescue Stripe::handle_api_error => e
      # return e
    rescue Stripe::general_api_error => e
      # return e
    rescue Stripe::StripeError => e
      # return e
  end

  begin
    charge = Stripe::Charge.create(
      :amount      => (params["cost"].to_i),
      :description => 'SleepBus ticket',
      :currency    => 'usd',
      :customer    => customer.id
    )
    rescue Stripe::CardError => e
      # return e
    rescue Stripe::AuthenticationError => e
      # return e
    rescue Stripe::StripeError => e
      # return e
    rescue Stripe::InvalidRequestError => e
      # return e
  end

  ticket_ids = []
  if charge["paid"] == true
    first_trip = Trip.find session[:trip_ids][0]
    second_trip = Trip.find session[:trip_ids][1] if session[:trip_ids][1]
    session[:passengers].each do |passenger|
      first_ticket = Ticket.create({
        passenger_id: passenger.id,
        trip_id: session[:trip_ids][0]
      })
      ticket_ids << first_ticket.id

      if session[:trip_ids][1]
        second_ticket = Ticket.create({
          passenger_id: passenger.id,
          trip_id: session[:trip_ids][1]
        })
        ticket_ids << second_ticket.id
      else
        second_ticket = nil
      end
      send_ticket_email(passenger, first_ticket, first_trip, second_trip)
    end
  else
    erb :checkout_err
  end

  erb :payment_success, :locals => {ticket_ids: ticket_ids}
end

def send_ticket_email(passenger, first_ticket, first_trip, second_trip)
  if passenger.email.present?
    email_body = erb :ticket_confirmation_email,
      layout: false,
      locals: {
        passenger: passenger,
        first_trip: first_trip,
        second_trip: second_trip
      }
    Pony.mail(
      to: passenger.email,
      from: "SleepBus <no-reply@sleepbus.co>",
      subject: "SleepBus Confirmation ##{(first_ticket.id + 1000)}",
      html_body: email_body
    )
  end
end
