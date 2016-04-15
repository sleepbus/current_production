get "/" do
	page_information = info_array = [
		{
			"header" 			=> "Book Any <br> Ticket for $48",
			"sub-header" 	=> "Whether you book 10 months before or 10 minutes before, the price never changes.",
			# old text: Whether you book 10 months <br> before or 10 minutes before the <br> price never changes
			"button" => "true",
			"base_image_url"	=> "/images/PHONE.png",
			"srcset_image_ulrs" => "/images/PHONE@2x.png 765w"
		},

		{
			"header" 			=> "Arrive Rested <br> & Ready",

			"sub-header" 	=> "Every passenger gets a private pod <br> with twin bed, premium bedding, <br> privacy curtain, outlet, and <br> reading light.",
			"button" => "true",
			"base_image_url"		=> "/images/bus-interior-0.jpg",
			"srcset_image_ulrs" => ""
		},
	]

	amenities_array = [
		{
			"image_url" => "/svgs/WIFI.svg",
			"text"			=> "Wifi on Every Bus"
		},
		{
			"image_url" => "/svgs/OUTLET.svg",
			"text" 			=> "Personal Power Outlets"
		},
		# {
		# 	"image_url" => "/svgs/UTENSILS.svg",
		# 	"text" 			=> "Free Coffee for the Whole Trip"
		# }
	]

	fhq_array = [
		{

			"question" => "What are the pick-up and drop-off locations?",
			"answer" => "
			San Francisco pick up and drop off: 4th and King Caltrain <br> Los Angeles pick up and drop off: Santa Monica Parking, 1550 Pacific Coast Highway.  "
		},
		{

			"question" => "What are the amenities on the SleepBus?",
			"answer" => "A privacy screen for each bed, personal power outlets, reading light, WiFi, fresh luxury sheets, coffee, tea, seating areas, and a restroom. There is also a SleepBus attendant on each trip to answer any of your questions and to take care of you during the ride."
		},
		{

			"question" => "Is there WiFi on the SleepBus?",
			"answer" => "Yes. We ask our passengers to not use video-streaming devices or services during the SleepBus ride to ensure quality of WiFi for the rest of the passengers.
"
		},
		{

			"question" => "What linens are used on the bus?",
			"answer" => "We are using 100% cotton sheets."
		},
		{

			"question" => "How early should I arrive for check in and how long can I stay before I need to check out?",
			"answer" => "You should aim to arrive at the pick up location 10-20 minutes before departure. Departure time is 11pm sharp in both San Francisco and Los Angeles. After we get to LA/SF in the morning, you'll be able to keep sleeping until 10:30am :)"
		},
		{

			"question" => "How long is the bus ride?",
			"answer" => "Given normal traffic and weather conditions, the average bus ride lasts 6-6.5 hours.
"
		},
		{

			"question" => "What are the departure and arrival times in SF and LA?",
			"answer" => "Departure time will always be 11pm sharp. Arrival times will vary, though we expect to arrive in either city by 5am or 6am."
		}
	]
	erb :landing, :locals => { info_array: page_information, amenities_array: amenities_array, fhq_array: fhq_array}
end



