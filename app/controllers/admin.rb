['/admin/index', '/admin/tickets'].each do |path|
  before path do
    redirect '/admin/login' unless session[:admin_ok] == true
  end
end

get "/admin/tickets" do
  @tickets = Ticket.all.includes(:passenger, :trip)
	erb :"admin/tickets", layout: :layout_admin
end

get "/admin/login" do
	erb :"admin/login", layout: :layout_admin
end

post "/admin/authenticate" do
  if params[:pass] == 'bus1234'
    session[:admin_ok] = true
    redirect '/admin/index'
  else
    redirect '/admin/login'
  end
end

get "/admin/index" do
	erb :"admin/index", layout: :layout_admin
end
