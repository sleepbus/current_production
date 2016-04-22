#trip and passenger show still need before_filters
['/admin/index', '/admin/tickets', '/admin/trips'].each do |path|
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

get "/admin/tickets" do
  @tickets = Ticket.all.includes(:passenger, :trip)
	erb :"admin/tickets", layout: :"admin/layout"
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
