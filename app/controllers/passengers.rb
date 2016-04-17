#params are coming in like this {"0_passenger"=>{"0"=>{"name"=>"0_first_name", "value"=>"Shayanne"}, "1"=>{"name"=>"0_last_name", "value"=>"Wright"}, "2"=>{"name"=>"0_email", "value"=>"shayanright@gmail.com"}}}
post "/passengers" do
	begin
		trip_price_multiplier = 4800
    trip_ids = params["busID"].split(",").map{|bus_id| bus_id.strip.to_i }
		passengers = []

    if trip_ids.first == 0 #this trip is after May 2nd and not available
      session[:fake_trip] = true
      session[:fake_passenger_ids] = []
      params["passengersInfo"].each_key do |key|
        fake_passenger = FakePassenger.find_or_create_by({
          first_name: params["passengersInfo"][key]["0"]["value"],
          last_name: params["passengersInfo"][key]["1"]["value"],
          phone_number: params["passengersInfo"][key]["2"]["value"],
          email: params["passengersInfo"][key]["3"]["value"]
        })
        if fake_passenger.save
          session[:fake_passenger_ids] << fake_passenger.id
          passengers << fake_passenger
        end
      end
    else
      session[:fake_trip] = false
      params["passengersInfo"].each_key do |key|
        passenger = Passenger.find_or_create_by({
          first_name: params["passengersInfo"][key]["0"]["value"],
          last_name: params["passengersInfo"][key]["1"]["value"],
          phone_number: params["passengersInfo"][key]["2"]["value"],
          email: params["passengersInfo"][key]["3"]["value"]
        })
        passengers << passenger if passenger.save
      end
      trips = [Trip.find(trip_ids[0])]
      if trip_ids.length > 1
        trips.push(Trip.find(trip_ids[1]))
        trip_price_multiplier = (trip_price_multiplier * 2)
      end
    end
    content_type :json
    checkoutTemplate = erb :checkout_review,
      layout: false,
      locals: {
        trips: trips,
        passengers: passengers,
        trip_price_multiplier: trip_price_multiplier
      }
    session[:passengers] = passengers
    session[:trip_ids] = trip_ids
    return checkoutTemplate.to_json
	rescue ActiveRecord::ConnectionTimeoutError => e
		puts e
	end
end
