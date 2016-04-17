post "/fake_tickets" do
  session[:fake_passenger_ids].each do |fake_passenger_id|
    fake_ticket = FakeTicket.new({
      fake_passenger_id: fake_passenger_id,
      depart_city_id: session[:depart_city_id],
      depart_date: Date.strptime(session[:depart_date], "%m/%d/%Y")
    })
    if session[:round_trip]
      fake_ticket.return_depart_city_id = session[:return_depart_city_id]
      fake_ticket.return_depart_date = Date.strptime(session[:return_depart_date], "%m/%d/%Y")
    end
    fake_ticket.save
  end
end
