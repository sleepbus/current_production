var ticketPriceCents = 4800;
var Model = {
	sendRoundTripDetails: function(tripData){
		$.ajax({
			url: "/trips/round",
			method: "POST",
			dataType: "json",
			data: tripData
		}).done(function(response){
			View.removeCityToggle()
			View.updateFormArea(response)
			// if (response.status == 200){
			// 	$(".direction-selection-holder").remove();
			// 	View.updateFormArea(response)
			// } else {
			// 	View.displayFormError(response)
			// }
		});
	},
	// Note these to ajax calls could just go to one route /trips and have the logic for trip type done on the backend but I like the modularity of seperate routes
	sendOneWayTripDetails: function(tripData){
		$.ajax({
			url: "/trips/oneway",
			method: "POST",
			dataType: "json",
			data: tripData
		}).done(function(response){
			View.removeCityToggle()
			View.updateFormArea(response)
			// if (response.status == 200){
			// 	$(".direction-selection-holder").remove();
			// 	View.updateFormArea(response)
			// } else {
			// 	View.displayFormError(response)
			// }
		});
	},

	getAvailableDatesForXAdults: function(number_of_adults, depart_city_id, return_city_id){
		$.ajax({
			url: "/trips/availability",
			method: "GET",
			data: {
				number_of_adults: number_of_adults,
				depart_city_id: depart_city_id,
				return_city_id: return_city_id
			}
		}).done(function(response){
			View.updateAvailableDates(response[0], response[1]);
		})
	},

	sendPassengerInfo: function(UserInfoHash) {	// Usually passed {passengersInfo: 	passengersInfo, busID: $(".trip-id").html()}
		$.ajax({
			url: "/passengers",
			method: "POST",
			dataType: "json",
			data: UserInfoHash
		}).done(function(response){
			var formArea = $(".form-area");
			formArea.empty();
			$(".confirmation-view").html(response);
		});
	},

	sendStripPaymentDetails: function(StripePaymentInfo){
		$.ajax({
			url: "/stripe/charge",
			method: "POST",
			data: StripePaymentInfo
		}).done(function(confirm_html){
			$(".form-area").empty();
			$(".stripe-checkout-success").css("display", "block");
		});
	}

};

var View = {
	updateFormArea: function(newHTML){
			formArea = $(".form-area");
			formArea.empty();
			formArea.html(newHTML);
	},

	removeCityToggle: function(){
		$(".direction-selection-holder").remove()
	},

	displayFormError: function(message){
		$(".error-holder").html(message).css("display", "block")
	},

	updateAvailableDates: function(departTrips, returnTrips){
		var departDates = departTrips.map(function (trip) {return trip.depart_date})
		var returnDates = returnTrips.map(function (trip) {return trip.depart_date})// map to get the available dates for each direction of travel.
		$(".depart-date").datepicker("destroy");
		$('.depart-date').datepicker({
		    beforeShowDay: function(date){
		        var formatedDate = jQuery.datepicker.formatDate("yy-mm-dd", date);
		        return [departDates.indexOf(formatedDate) != -1]
		    },
		    minDate: 0
		});
		$(".return-date").datepicker("destroy");
		$('.return-date').datepicker({
		    beforeShowDay: function(date){
		        var formatedDate = jQuery.datepicker.formatDate("yy-mm-dd", date);
		        return [returnDates.indexOf(formatedDate) != -1]
		    },
		    minDate: 0

		});
		View.toggleDatePickerLoading();
	},

	updatePriceInSubmitText:  function(numPassengers, tripType){
		var price = 1;
		if (tripType == "round"){
			price = parseInt(numPassengers, 10) * ((ticketPriceCents * 2)/100);
		}
		else {
			price = parseInt(numPassengers, 10) * (ticketPriceCents/100);
		}
		$(".trip-details").attr("value", "Book now for $" + price);
	},

	toggleFollowNav: function(){
		appearfollowNav = $("#appear-follow-nav");
		followNavContianer = $(".follow-nav");
		if (appearfollowNav.css("display") == "flex"){
			appearfollowNav.slideUp();
			followNavContianer.css("display", "block");
		} else {
			appearfollowNav.slideDown();
			// $("landing-logo").toggle();
			appearfollowNav.css("display", "flex");
			followNavContianer.css("position", "fixed");
		}
	},

	setUpLanding: function(){
		// $('#depart-date').datepicker();
		// $('#return-date').datepicker();
		Model.getAvailableDatesForXAdults(1, $(".depart-city").data("city-id"), $(".return-city").data("city-id"));
		// debugger
		View.updatePriceInSubmitText($('.number_of_adults').val(), $(".trip-details").attr("data-trip-type"));
		if (window.location.pathname != "/begin-checkout"){
			var waypoint = new Waypoint({
				element: document.getElementById('switch-follow-nav-waypoint'),
				handler: View.toggleFollowNav
			});
		}
	},

	toggleToFromCities: function(){
		if ($(".direction-selection").css("flex-direction") == "row"){
			$(".direction-selection").css("flex-direction", "row-reverse");
		} else {
			$(".direction-selection").css("flex-direction", "row");
		}
		var orginal_depart_name = $(".depart-city").html();
		$(".depart-city").html($(".return-city").html());
		$(".return-city").html(orginal_depart_name);

		var orginal_depart_id = $(".depart-city").attr("data-city-id");
		$(".depart-city").attr("data-city-id", $(".return-city").attr("data-city-id"));
		$(".return-city").attr("data-city-id", orginal_depart_id);
	},

	getTripDetailsFormInfo: function(formObj, callback, tripType){
		var tripData = {};
    tripData["depart-date"] = formObj.find('input.depart-date').val();
    tripData["return-date"] = formObj.find('input.return-date').val();
		tripData["number_of_adults"] = formObj.find(".number_of_adults").val();
		tripData["departCityID"] = $(".depart-city").attr("data-city-id");
		tripData["arriveCityID"] = $(".return-city").attr("data-city-id");
		event.preventDefault();
		callback(tripData);
	},

	toggleDatePickerLoading: function(){
			if ($(".datepicker").css("display") == "none"){
				$(".datepicker").each(function(){
					$(this).css("display", "block");
				});
				$(".datepicker-loading").each(function(){
					$(this).css("display", "none");
				});
			} else {
				$(".datepicker").each(function(){
					$(this).css("display", "none");
				});
				$(".datepicker-loading").each(function(){
					$(this).css("display", "-webkit-inline-box");
				});
			}
	}
};




startListeners = function(){
	$('#switch').click(function(){
		View.toggleToFromCities(); // switches the user seeable text for the cities also updates the data-city-id for both .depart-city and .return-city
		Model.getAvailableDatesForXAdults(
			$('.number_of_adults').val(),
			$(".depart-city").attr("data-city-id"),
			$(".return-city").attr("data-city-id")
		);
		View.toggleDatePickerLoading();
	});

	// $(document).on("click", ".div-line-text", function(){ // $(document) selector has to be used for ajaxed in html
		// View.toggleToFromCities() // switches the user seeable text for the cities also updates the data-city-id for both .depart-city and .return-city
		// Model.getAvailableDatesForXAdults(
			// $('.number_of_adults').val(),
			// $(".depart-city").attr("data-city-id"),
			// $(".return-city").attr("data-city-id")
		// )
		// View.toggleDatePickerLoading()
	// });

	$(".trip-details-form").submit(function(event){
		var tripType = $(".trip-details").attr("data-trip-type");
		if (tripType == "round") {
			View.getTripDetailsFormInfo($(this), Model.sendRoundTripDetails, tripType); // gets the data from the form then sends it as a param to the callback
		} else {
			View.getTripDetailsFormInfo($(this), Model.sendOneWayTripDetails, tripType); //
		}
	});

	$('.number_of_adults').change(function(event){
		View.updatePriceInSubmitText($(this).val(), $(".trip-details").attr("data-trip-type"));
		Model.getAvailableDatesForXAdults(
			$(this).val(),
			$(".depart-city").attr("data-city-id"),
			$(".return-city").attr("data-city-id")
		); // gets available dates for the next 2 months for however many passengers are selected then passes this to updateAvailableDates() which blocks out non-avaible dates for that many passengers
		// Security Note: blocking out the available dates on the datepicker only works if the user has javascript enabled so we also have test in the model to make sure no trips are over booked. updateAvailableDates should be viewed a just a UI improvement and not a way of making sure trips aren't over booked
		View.toggleDatePickerLoading(); // We have to disable the date picker while the ajax call for availble dates is being made otherwise the user could select a date before the date picker is refreshed
	});

	$(document).on("click", ".send-user-info", function(event){
		event.preventDefault();
		var passengersInfo = {};
		$(".user-info-forms-holder").children('form').each(function(index){
			passengersInfo[index + "_passenger"] = $(this).serializeArray();
		});
		Model.sendPassengerInfo({passengersInfo: passengersInfo, busID: $(".trip-id").html()}); // send data from form to /passengers
	});

	$(document).on("submit", ".stripe-payment-form", function(event){
		event.preventDefault();
		Model.sendStripPaymentDetails($(this).serializeArray()); // sends stripe form data to /stripe/charge
	});

	$('input, select, textarea').bind('focus blur', function(event) {
		var $viewportMeta = $('meta[name="viewport"]');
		$viewportMeta.attr('content', 'width=device-width,initial-scale=1,maximum-scale=' + (event.type == 'blur' ? 10 : 1));
	});

	$(".datepicker").on("click", function () {
		$('.datepicker').css("position", "relative");
	});

  // this stuff needs to be cleaned up a lot
	$(document).on("click", "#one-way", function(event){
		event.preventDefault();
		$(this).toggleClass("non-selected");
		$("#roundtrip").toggleClass("non-selected");
		$(this).toggleClass("selected");
		$("#roundtrip").toggleClass("selected");
		$(".return-date-select").css("display", "none");
		$(".trip-details").attr("data-trip-type", "one-way");
		$(".direction-selection-icon").removeClass("icon-loop");
		$(".direction-selection-icon").addClass("icon-arrow-right");
		View.updatePriceInSubmitText($('.number_of_adults').val(), $(".trip-details").attr("data-trip-type"));
	});

	$(document).on("click", "#roundtrip", function(event){
		event.preventDefault();
		$(this).toggleClass("non-selected");
		$(this).toggleClass("selected");
		$("#one-way").toggleClass("non-selected");
		$("#one-way").toggleClass("selected");
		$(".return-date-select").css("display", "block");
		$(".trip-details").attr("data-trip-type", "round");
		$(".direction-selection-icon").removeClass("icon-arrow-right");
		$(".direction-selection-icon").addClass("icon-loop");
		View.updatePriceInSubmitText($('.number_of_adults').val(), $(".trip-details").attr("data-trip-type"));
	});

	// $(document).on("click", ".mobile-book-trip", function(event){
	// 	event.preventDefault();
	// 	$(".modal").css("display", "flex");
	// });

	$(document).on("click", ".book-trip, .mobile-book-trip, .book-trip-no-disappear", function(event){
		event.preventDefault();
	  window.location.href = "/begin-checkout";
		//  if (isMobile.matches){ // if mobile we load a new page if desktop its ajaxed into a modal
		//  window.location.href = "/begin-checkout";
		//} else {
		//	$(".modal").css("display", "flex");
		//}
	});

	$(".modal-close").click(function(event){
		event.preventDefault();
		$(".modal").css("display", "none");
	});
};

$(document).ready(function() {
	paginit()
});

paginit = function(){
	isMobile = window.matchMedia("only screen and (max-width: 760px)");
	View.setUpLanding();
	startListeners();
}
