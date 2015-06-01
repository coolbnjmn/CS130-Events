exports.getAttendees = function(request, response) {

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
}