get "/begin-checkout" do
	erb :mobile_trip_form
end

post "/trips/round" do
	begin
		content_type :json

	 	trip = Trip.find_by(
			depart_date: Date.strptime(params["depart-date"], "%m/%d/%Y"),
			depart_city_id: params["departCityID"],
			end_city_id: params["arriveCityID"]
		)
		if trip && trip.seats_left >= params["number_of_adults"].to_i # serverside check for seat avaiblity
			return_trip = Trip.find_by(
				depart_date:  Date.strptime(params["return-date"], "%m/%d/%Y"),
				depart_city_id: params["arriveCityID"],
				end_city_id: params["departCityID"]
			)
			HTMLtemplate = erb :user_info_form,
				:layout => false,
				:locals => {
					trip_ids: [trip.id, return_trip.id],
					number_of_passengers: params["number_of_adults"]
				}
				status 200
			return HTMLtemplate.to_json
		else
			status 406
			return "Sorry Doesn't look like we have any more seats available on that route".to_json
		end
	rescue ActiveRecord::ConnectionTimeoutError => e
		puts e
	end

end

post "/trips/oneway" do
	begin
		trip = Trip.find_by(
				depart_date: Date.strptime(params["depart-date"], "%m/%d/%Y"),
				depart_city_id: params["departCityID"],
				end_city_id: params["arriveCityID"]
			)
		if trip && trip.seats_left >= params["number_of_adults"].to_i
				HTMLtemplate = erb :user_info_form,
				:layout => false,
				:locals => {
					trip_ids: [trip.id],
					number_of_passengers: params["number_of_adults"]
				}
			return HTMLtemplate.to_json
		else
			# status 406
			# return "Sorry Doesn't look like we have any more seats available on that route".to_json
		end
	rescue g=> e
		puts e
	end
end

get "/trips/availability" do
	begin
		num_passengers = params["number_of_adults"].to_i
		depart_trips = Trip.where(depart_city_id: params["depart_city_id"], depart_date: Date.today..Date.today.to_time.advance(:months => 2).to_date)
		if depart_trips.length > 0
			depart_trips = depart_trips.reject do |trip_ob|
				num_passengers > trip_ob.seats_left
			end
		end
		return_trips = Trip.where(depart_city_id: params["return_city_id"], depart_date: Date.today..Date.today.to_time.advance(:months => 2).to_date)

		if return_trips.length > 0
			return_trips = return_trips.reject do |trip_ob|
				num_passengers > trip_ob.seats_left
			end
		end
	rescue ActiveRecord::ConnectionTimeoutError => e
		puts e
	end

	content_type :json
	if return_trips
		return [depart_trips, return_trips].to_json
	else
		return [depart_trips].to_json
	end
end

