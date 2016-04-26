#trip and passenger show still need before_filters
['/admin/index', '/admin/tickets', '/admin/trips', '/admin/passenger/*', '/admin/trip/*', '/admin/trip/*/ticket/*/refund'].each do |path|
  before path do
    redirect '/admin/login' unless session[:admin_ok] == true
  end
end

get "/admin/trips" do
  @trips = Trip.all.includes(:depart_city).order('depart_date ASC')
	erb :"admin/trips", layout: :"admin/layout"
end

get "/admin/trip/:id" do
  @trip = Trip.includes(:tickets).find_by(id: params[:id])
  if @trip
	  erb :"admin/trip", layout: :"admin/layout"
  else
    redirect '/admin/trips'
  end
end

get "/admin/passenger/:id" do
  @passenger = Passenger.includes(:tickets).find_by(id: params[:id])
  if @passenger
	  erb :"admin/passenger", layout: :"admin/layout"
  else
    redirect '/admin/trips'
  end
end

post "/admin/passengers/lookup" do
  passenger = Passenger.find_by email: params[:email]
  if passenger
    redirect "/admin/passenger/#{passenger.id}"
  else
    redirect '/admin/index'
  end
end

get "/admin/fake_trips/:month" do
  @month_name = params[:month]
  @first_of_month = return_date_obj_from_month_name(@month_name)
  @end_of_month = @first_of_month.end_of_month
	erb :"admin/fake_trips", layout: :"admin/layout"
end

get "/admin/fake_trip/:date" do
  @date_obj = Date.parse params[:date]
  @fake_tickets = FakeTicket.includes(:fake_passenger).where(depart_date: @date_obj)
	erb :"admin/fake_trip", layout: :"admin/layout"
end

get "/admin/trip/:id/ticket/:ticket_id/refund" do
  trip = Trip.find_by id: params[:id]
  ticket = Ticket.find_by id: params[:ticket_id]
  if trip && ticket
    ticket.update_attribute :refunded, true
    trip.increment! :seats_left
    redirect "/admin/trip/#{trip.id}"
  else
    redirect '/admin/index'
  end
end

get "/admin/login" do
	erb :"admin/login", layout: :"admin/layout"
end

post "/admin/authenticate" do
  if params[:pass].present?
    if params[:pass].downcase == 'bus1234'
      session[:admin_ok] = true
      redirect '/admin/index'
    else
      redirect '/admin/login'
    end
  else
    redirect '/admin/login'
  end
end

get "/admin/index" do
	erb :"admin/index", layout: :"admin/layout"
end
