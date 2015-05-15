var creds = require('cloud/credentials.js');

/**
* Finds a Flickr photo for the event cover based on the given text about an event
* Optionally include latitude and longitude coordinates to perform a location based search on the same text
*
* @param {string} request.params.title The text to be searched for on Flickr
* OPTIONAL PARAMS:
* @param {double} request.params.lat Latitude in decimal form to center the search around
* @param {double} request.params.lon Longitude in decimal form to center the search around
* @return {string} either returns an error message or the URL for the Flickr photo
*/
Parse.Cloud.beforeSave("Event", function(request, response) {

	if(request.object.get("image_url")) {
		response.success(request.object);
	}

	var searchText = request.object.get("title");

	params = {
		method: 'flickr.photos.search',
	  	api_key:  creds.getFlickrConfig(),
	  	text: searchText,
	  	per_page: 20,
	    format: 'json', 
		nojsoncallback: 1, 
		geocontext: 2,
		content_type: 1,
		sort: 'relevance',
		license: '4,5,6,7'// All commercially allowed licenses - ids found from https://www.flickr.com/services/api/flickr.photos.licenses.getInfo.html
	}

	// if (request.params.hasOwnProperty('lat') && request.params.hasOwnProperty('lon')) {
	// 	params['lat'] = request.params.lat;
	// 	params['lon'] = request.params.lon;

	// 	// Define the radius of the geo-search, up to 20 miles
	// 	params['radius'] = 20;
	// 	params['radius_units'] = "mi";
	// }		


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
		    	response.success(request.object);
		    }
		    else {
		    	// Use the first photo as the image to return
			    firstPhoto = data['photos']['photo'][0];

			    // Choose the size of the photo, probably more programatically than this
			    thumbnail = false;
			    size = thumbnail ? "m" : "b";

			    // Construct URL for the flickr photo
				photoURLString = "http://farm" + firstPhoto['farm'] + ".staticflickr.com/" + firstPhoto['server'] + "/" + firstPhoto['id'] + "_" + firstPhoto['secret'] + "_" + size + ".jpg";

				// Save the constructed URL in the event object
				request.object.set("image_url", photoURLString);

				// Save the event object and pass it back to the client
			    response.success(request.object);
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
        Body: "Hi " + user.get("first_name") + "! Your verification code is " + verificationCode + "."
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




/**
* First, create new users if phone numbers in the invitees do not exist as users already
* Then, send invitations either via text or via push notification to the invitees about eventId event
*/

Parse.Cloud.define("sendInvitations", function(request, response) {
    var eventId = request.params.eventId;
    var invitees = request.params.invitees;
    //Create User Objects
    createUsersFromInvitees(invitees, function(err, users) {
      if (err) {
        response.error(err);
      } else {

        response.success("Success");

     //    for(var i = 0; i < users.length; i++) {
    	// 	console.log(users[i]);
    	// }

        createInvitations(users, eventId, function(err) {

        });
        
      }
    });
});

function createInvitations(users, eventId) {

        for(var i = 0; i < users.length; i++) {
        	if(users[i].get('facebookId')) {
        		// send push notification
        		console.log('push')
        	} else {
        		// send text via twilio
        		console.log('text')
        		var credentials = creds.getTwilioConfig();
			    var twilio = require('twilio')(credentials.AccountSID, credentials.AuthToken);

			    var Event = Parse.Object.extend("Event");
			    var query = new Parse.Query(Event);
                console.log("about to query");
                // Event query not working yet
			    query.get(eventId, {
			        success: function (result) {
                        console.log(result);
			            
			                // var event = results[0];
                   //          var creator = event.get('host').get('first_name');
                   //          console.log(event);
                   //          console.log(creator);
		        //         	twilio.sendSms({
						    //     From: "(818) 877-4527",
						    //     To: users[i].get('phoneNumber'),
						    //     Body: "Hi " + users[i].get("first_name") + "! You have been invited to event " + event + "."
						    // }, function(err, responseData) { 
						    //     if (err) {
						    //       response.error(err);
						    //     } else { 
						    //       response.success("Success");
						    //     }
						    // });
			            
			        },
			        error: function (error) {
			            console.log("Error in get Event query");
			            //callback(error);
			        }
			    });



        	}
    	}
}

/**
* Go through each invitee, check the phone number for existence in the database already
*
*
*/

function createUsersFromInvitees(invitees, callback) {
    //Create new Parse Users for each invitee if they do not exists
    var users = [];
    for (var i=0; i < invitees.length; i++) {
        checkPhoneNumber(invitees[i], function (err, user) {
            if (err) {
                return callback(err);
            }
            if (user) {
                users.push(user);
                if (users.length === invitees.length) {
                  return callback(null, users);
                }
            }
        });
    }
}


/**
* Logic to create new user if he/she does not already exist
*
*/
function checkPhoneNumber(invitee, callback) {
    //Check if user already exists by looking up phone number
    userExists(invitee.phoneNumber, function (err, user) {
        if (err) {
            return callback(err);
        }

        if (!user) {
            var user = new Parse.User();
            var fullName = invitee.name;
            var nameArr = fullName.split(" ");
            user.set("username", "textuser_" + invitee.phoneNumber);
            user.set("password", "resUtxeT");
            user.set("phoneNumber", invitee.phoneNumber);
            user.set("full_name", fullName);
            user.set("first_name", nameArr[0]);
            user.set("last_name", nameArr[(nameArr.length-1)]);
            user.signUp(null, {
                success: function (user) {
                    callback(null, user);
                },
                error: function (user, error) {
                  console.log("User could not be signed up: " + error.message);
                  callback(err);
                }
            });
        } else {
          callback(null, user);
        }
    });
    
}
/**
* Check if there exists a user with the given phone number
* Return the user if he/she exists, or false if he/she does not
*
*/
function userExists(phoneNumber, callback) {
    var query = new Parse.Query(Parse.User);
    query.equalTo("phoneNumber", phoneNumber);
    query.find({
        success: function (results) {
            if (results.length) {
                return callback(null, results[0]);
            }
            callback(null, false);
        },
        error: function (error) {
            console.log("Error in phoneNumber User query");
            callback(error);
        }
    });
}





