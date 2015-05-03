var creds = require('cloud/credentials.js');

/**
* Finds a Flickr photo for the event cover based on the given text about an event
* Optionally include latitude and longitude coordinates to perform a location based search on the same text
*
* @param {string} request.params.text The text to be searched for on Flickr
* OPTIONAL PARAMS:
* @param {double} request.params.lat Latitude in decimal form to center the search around
* @param {double} request.params.lon Longitude in decimal form to center the search around
* @return {string} either returns an error message or the URL for the Flickr photo
*/
Parse.Cloud.define("flickr", function(request, response) {
	var FLICKR_API_KEY = "1841d87292afbe9c627a5b82cf1416df";
	var searchText = request.params.title;

	params = {
		method: 'flickr.photos.search',
	  	api_key:  FLICKR_API_KEY,
	  	text: searchText,
	  	per_page: 20,
	    format: 'json', 
		nojsoncallback: 1, 
		geocontext: 2,
		content_type: 1,
		sort: 'interestingness-desc',
		license: '4,5,6,7'// All commercially allowed licenses - ids found from https://www.flickr.com/services/api/flickr.photos.licenses.getInfo.html
	}

	if (request.params.hasOwnProperty('lat') && request.params.hasOwnProperty('lon')) {
		params['lat'] = request.params.lat;
		params['lon'] = request.params.lon;

		// Define the radius of the geo-search, up to 20 miles
		params['radius'] = 20;
		params['radius_units'] = "mi";
	}		


	Parse.Cloud.httpRequest({
	  method: "GET",
	  url: "https://api.flickr.com/services/rest/",
	  // params - found on flickr api: https://www.flickr.com/services/api/flickr.photos.search.html
	  params: params,
	  success: function(httpResponse) {
	  		// JSON response from Flickr with first 20 photos 
		    data = httpResponse.data;

		    // Uncomment below to see the entire httpResponse
		    //console.log(httpResponse.text);

		    if(data['photos']['total'] == 0) {
		    	response.error("No photo results");
		    }
		    else {
		    	// Use the first photo as the image to return
			    firstPhoto = data['photos']['photo'][0];

			    // Choose the size of the photo, probably more programatically than this
			    thumbnail = true;
			    size = thumbnail ? "m" : "b";

			    // Construct URL for the flickr photo
				photoURLString = "http://farm" + firstPhoto['farm'] + ".staticflickr.com/" + firstPhoto['server'] + "/" + firstPhoto['id'] + "_" + firstPhoto['secret'] + "_" + size + ".jpg";

				// Send the constructed URL back as the response
			    response.success(photoURLString);
		    }

		},
	  error: function(httpResponse) {
		    response.error('Request failed with response code ' + httpResponse.status);
		}
	});
});


/**
* Send verification code to given phone number and store that code in the user object
* Randomly generates a 6 digit number and sets it to the current user, and then sends the text using twilio
*
* @param {string} request.params.phoneNumber The user's enterred phone number to be verified
* @return {HTTPResponse} either returns an error message or the word Success.
*/
Parse.Cloud.define("sendVerificationCode", function(request, response) {
    var verificationCode = Math.floor(Math.random()*999999);
    var user = Parse.User.current();
    user.set("phoneNumber", request.params.phoneNumber);
    user.set("phoneVerificationCode", verificationCode);
    user.save();
    var credentials = creds.getTwilioConfig();
    var twilio = require('twilio')(credentials.AccountSID, credentials.AuthToken);

    twilio.sendSms({
        From: "(818) 877-4527",
        To: request.params.phoneNumber,
        Body: "Your verification code is " + verificationCode + "."
    }, function(err, responseData) { 
        if (err) {
          response.error(err);
        } else { 
          response.success("Success");
        }
    });
});

/**
* Verify the given code with the user's phone number to make sure it's the right code
*
* @param {string} request.params.phoneVerificationCode The user's enterred verification code to be verified
* @return {HTTPResponse} either returns an error message or the word Success.
*/

Parse.Cloud.define("verifyPhoneNumber", function(request, response) {
    var user = Parse.User.current();
    var verificationCode = user.get("phoneVerificationCode");
    if (verificationCode == request.params.phoneVerificationCode) {
        user.set("phoneValidated", true);
        user.save();
        response.success("Success");
    } else {
        response.error("Invalid verification code.");
    }
});