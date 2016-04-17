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
    session[:passengers].each do |passenger|
      ticket = Ticket.create({
        passenger_id: passenger.id,
        trip_id: session[:trip_ids][0]
      })
      ticket_ids << ticket.id

      if session[:trip_ids][1]
        ticket = Ticket.create({
          passenger_id: passenger.id,
          trip_id: session[:trip_ids][1]
        })
        ticket_ids << ticket.id
      end
    end
  else
    erb :checkout_err
  end

  erb :payment_success, :locals => {ticket_ids: ticket_ids}
end
