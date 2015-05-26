var creds = require('cloud/credentials.js');

var moment = require('moment');
var express = require('express');
var app = express();

// Global access to twilio
var credentials = creds.getTwilioConfig();
var twilio = require('twilio')(credentials.AccountSID, credentials.AuthToken);

// Global app configuration section
app.use(express.bodyParser());  // Populate req.body

// set up route for receiving texts
app.post('/invitationResponse', handleInvitationResponse);

app.listen();

function handleInvitationResponse(request, response) {
    console.log(request.body);
    var textResp = request.body.Body; 
    var phoneNum = request.body.From;
    // strip the +1 from the phone number
    phoneNum = phoneNum.replace(/^\+1/i, '');
    console.log(phoneNum);
    textResp = textResp.toLowerCase();

    userExists(phoneNum, function (err, user) {
        getInvitationObjectForTextUser(user, function(err, status, inviteObj) {
            console.log(inviteObj);
            console.log(textResp);
            if(!inviteObj) {
                // Send text that says there is no invitation to respond to
                console.log("no invitation to respond to");
            }
            else if(/*status == "single"*/ true) {
                handleSingleInvitationResponse(inviteObj, user, textResp);
            }
            
        });


    })

}

function handleSingleInvitationResponse(inviteObj, user, textResp) {
    var responseMsg = "";
    var eventObj = inviteObj.get('event');
    if(textResp == "yes") {
        // accept invite
        // find the invitation for the specific user and this event
        // set the response to true
        console.log("accepting");
        inviteObj.set('response', true);
        // send text response when complete
        responseMsg = "Congrats! You have successfully joined the event " + eventObj.get('title') + "!";
    } else if (textResp == "no") {
        // reject invite
        // find the invitation for the specific user and this event
        // set the response to false
        console.log("rejecting");
        inviteObj.set('response', false);
        // send text response when complete
        responseMsg = "You have successfully declined the invitation to the event " + eventObj.get('title') + ".";
    } else if (textResp == "more") {
        console.log("more info");

        // text bobby for more information or download the Udder app from the app store...

        // respond with more info
        // find more info on this event

        //moment().;
// moment.parseZone(eventObj.get('start_time'));
//         console.log(moment(eventObj.get('start_time')).zone("-08:00"));

        // var month = d_start.getMonth() + 1;
        // var hour = d_start.getHours(); 
        // var timeOfDay = "am";
        // if(hour > 12) {
        //     hour -= 12;
        //     timeOfDay = "pm";
        // } else if(hour == 0) {
        //     hour = 12;
        // }
        // var formattedDate = month + "/" + d_start.getDate() + "/" + d_start.getFullYear() + " at " +
        //                     d_start.getHours() + ":" + d_start.getMinutes() + " " + timeOfDay;
        // console.log(formattedDate);


        // responseMsg = //"Detailed information for event " + eventObj.get('title') + ":\n\n" +
        //              // "Time: " + d_start. + " to " + eventObj.get('end_time') + "\n\n" +
        //               "Location: " + eventObj.get('location') + "\n\n" +
        //               "Description: " + eventObj.get('description') + "\n\n" +
        //               "Reply YES | NO.";

        responseMsg = "Text " + eventObj.get('host').get('full_name') + " or download the Udder app for more information. Reply to accept or decline the invite: YES | NO.";
        console.log(responseMsg.length);

        // send text response with event details
    } else {
        console.log("invalid");
        responseMsg = "Please enter a valid response. Reply YES | NO | MORE."
        // send text response invalid command
    }

    //var twiml = new twilio.TwimlResponse();
    //response.type('text/xml');

    inviteObj.save(null, {
        success: function (result) {
            //twiml.message("Success");
            twilio.sendSms({
                From: "(818) 877-4527",
                To: user.get("phoneNumber"),
                Body: responseMsg
            }, function(err, responseData) { 
                if (err) {
                    console.log(err);
                  console.log("TExt FAILEDDDD");
                } else { 
                  console.log("Text succeeedeeddddeded");
                }
            });
            //response.send('Success');
        },
        error: function (error) {
            //response.send('Error');
        }
    });
}

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
    //  params['lat'] = request.params.lat;
    //  params['lon'] = request.params.lon;

    //  // Define the radius of the geo-search, up to 20 miles
    //  params['radius'] = 20;
    //  params['radius_units'] = "mi";
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
* get the Attendees for the a specific event
*
* @param {string} request.params.eventId T
* @return {list of invitations that have } either returns an error message or the word Success.
*/

Parse.Cloud.define("getAttendees", function(request, response) {
    var eventId = request.params.eventId;
    var Event = Parse.Object.extend("Event");
    var eventQuery = new Parse.Query(Event);
    eventQuery.equalTo("objectId", eventId);

    var Invitation = Parse.Object.extend("Invitation");
    var invitationQuery = new Parse.Query(Invitation);
    invitationQuery.matchesQuery("event", eventQuery);
    invitationQuery.equalTo("response", true);
    invitationQuery.include("user");
    invitationQuery.select("user.full_name", "user.phoneNumber", "user.facebookId");

    invitationQuery.find({
        success: function (results) {
            response.success(results);
        },
        error: function (error, result) {
            response.error("ERROR! Attendees not returned");
        }
    }); 
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
            return response.error(err);
        }
        //Create invitation objects to save to db
        handleInvitations(users, eventId, function(err, eventObj, usersToNotify) {
            if (err) {
                return response.error(err);
            }
            notifyUsers(usersToNotify, eventObj, function(err) {
                if (err) {
                    return response.error(err);
                }
                // Add this back at some point. Stops the running of async calls for some reason
                //response.success("Success");
            });
        });
    });
});

/**
* Create Invitation objects for all users
* Return error if save not successful, otherwise return to callback function
*
*/
function handleInvitations(users, eventId, callback) {
    var totalUsers = 0;

    getEventObject(eventId, function (err, eventObj) {
        var newUsers = [];
        console.log(users.length);
        for(var i = 0; i < users.length; i++) {

            createInvitation(users[i], eventObj,  function (err, userToNotify) {
                if (err) { return callback(err); }
                if (userToNotify) {
                    console.log("Not duplicate user");
                    newUsers.push(userToNotify);
                } 
                console.log(newUsers);
                if (++totalUsers === users.length) {
                    callback(null, eventObj, newUsers);
                }
            });
        }
    });
    
}

function getInvitationObjectForTextUser(user, callback) {
    //Query for event object using ID
    var Invitation = Parse.Object.extend("Invitation");
    var query = new Parse.Query(Invitation);
    query.equalTo("user", user);
    query.equalTo("response", null);
    query.include("event");
    query.include("event.host");
    // sort by most recent invitation
    query.descending("createdAt");
    query.find({
        success: function (invitations) {
            // TODO: Add support for a user having more than one invitation
            console.log("Invitation Object Returned: " + JSON.stringify(invitations));
            if(invitations.length) {
                if (invitations.length > 1) {
                    return callback(null, "multiple", invitations);
                }
                return callback(null, "single", invitations[0]);
            } else {
                callback("no result for invitation");
            }

        },
        error: function (error, result) {
            console.log("ERROR! Invitation object not returned");
            callback(true);
        }
    });
}

function getEventObject(eventId, callback) {
    //Query for event object using ID
    var Event = Parse.Object.extend("Event");
    var query = new Parse.Query(Event);
    query.get(eventId, {
        success: function (result) {
            //possibly result[0]
            console.log("Event Object Returned: " + result);
            console.log(JSON.stringify(result));
            callback(null, result);
        },
        error: function (error, result) {
            console.log("ERROR! Event object not returned");
            callback(true);
        }
    });
}

function getCreatorObject(creatorId, callback) {
    //Query for creator object using ID
    //console.log(creatorId);
    var query = new Parse.Query(Parse.User);
    query.equalTo("objectId", creatorId);
    query.find({
        success: function (result) {
            if(result.length) {
                callback(null, result[0]);
            } else {
                callback("No results for user");
            }
        },
        error: function (error) {
            console.log("Error User in query");
            callback(error);
        }
    });
}

function notifyUsers(users, eventObj, callback) {

    var appUsers = [];
    var textUsers = [];

    console.log(users);
    for(var i = 0; i < users.length; i++) {
        //Alert Users
        if(users[i].get('facebookId')) {
            //Add user to appUsers array
            appUsers.push(users[i]);
            console.log('push');
        } else {
            //Add user to textUsers array
            textUsers.push(users[i]);
            console.log('text');
        }
    }

    var creatorId = eventObj.get('host').id;

    getCreatorObject(creatorId, function (err, creator) {
        //console.log('got the creator')
        //Send text invites via Twilio for non-app users
        for(var i = 0; i < textUsers.length; i++) {
            sendTextInvite(textUsers[i], eventObj, creator);
        }
        //Send push notifications for in-app users
        for (var i = 0; i <appUsers.length; i++) {
            sendPushInvite(appUsers[i], eventObj, creator);
        }
        callback(null);
    });


}

function sendTextInvite(user, eventObj, creator) {
    var credentials = creds.getTwilioConfig();
    var twilio = require('twilio')(credentials.AccountSID, credentials.AuthToken);

    var body = "Hi " + user.get("first_name") + "! You have been invited to attend " + eventObj.get('title') + " by " + creator.get('full_name') + ". Reply YES | NO | MORE";

    twilio.sendSms({
        From: "(818) 877-4527",
        To: user.get('phoneNumber'),
        Body: body
    }, function(err, responseData) { 
        console.log("Response Data");
        console.log(responseData); 

          return true;
    });
            
}

function sendPushInvite (user, eventObj, creator) {
    // Find users near a given location
    var userQuery = new Parse.Query(Parse.User);
    userQuery.equalTo("objectId", user.id);


    // Find devices associated with these users
    var pushQuery = new Parse.Query(Parse.Installation);
    pushQuery.matchesQuery('user', userQuery);

    var body = "Hi " + user.get("first_name") + "! You have been invited to attend " + eventObj.get('title') + " by " + creator.get('full_name') + ".";

    var Invitation = Parse.Object.extend("Invitation");
    var invitationQuery = new Parse.Query(Invitation);
    invitationQuery.equalTo("event", eventObj);
    invitationQuery.equalTo("user", user);

    invitationQuery.find({
        success: function(invites) {
            //console.log(JSON.stringify(invites));
            // Send push notification to query
            Parse.Push.send({
              where: pushQuery,
              data: {
                alert: body,
                type: "newInvitation",
                invitation: invites[0]
              }
            }, {
              success: function() {
                console.log("push success")
                // Push was successful
              },
              error: function(error) {
                // Handle error
                console.log("errrr")
              }
            });
        }, 
        error: function (error) {
            console.log("cannot find the invitation for this user")
        }
    })

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
            user.set("password", invitee.phoneNumber + "_pwd");
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

/**
* Create new Invitation object and save to db
* Return error if save not successful, otherwise return to callback function
*
*/
function createInvitation(user, eventObj, callback) {
    //Create Invitation Objects
    // TODO: Make sure invitation object is unique - do not create one if it already exists
    var Invitation = Parse.Object.extend("Invitation");

    // Verify that the invitation to be saved is unique before saving it
    // If it already exists in the database, do not create a new invitation
    var query = new Parse.Query(Invitation);
    query.equalTo("user", user);
    query.equalTo("event", eventObj);
    query.first({
      success: function(object) {
        if (object) {
            // CHANGE BACK TO false AFTER TESTING IS DONE
          callback(null, user);
        } else {
            var newInvite = new Invitation();
            //TODO: Query for event pointer
            newInvite.set("event", eventObj);
            //TODO: Check syntax of User
            newInvite.set("user", user);
            //TODO: Check syntax
            newInvite.save(null, {
                success: function (result) {
                    callback(null, user);
                },
                error: function (error) {
                    callback(true);
                }
            });
        }
      },
      error: function(error) {
        callback("Could not validate uniqueness for this Invitation object.");
      }
    });
}

