var expect = require('expect.js');
var tests = require('./tests.js');
var async = require('async');

var Parse = require("parse").Parse;
Parse.initialize("key 1", "key 2");

describe('sendInvitations', function () {

  var testEvent = {};
  before('creation', function (done) {
      var eventParams = {
        "address":"Los Angeles, CA, USA","category":"Fitness","description":"desc","end_time":{"__type":"Date","iso":"2015-05-31T03:55:20.000Z"},"geocoordinate":{"__type":"GeoPoint","latitude":34.0522342,"longitude":-118.2436849},"host":{"__type":"Pointer","className":"_User","objectId":"jAEDkEzDLR"},"image_url":"","location":"Los Angeles","private":false,"start_time":{"__type":"Date","iso":"2015-05-28T03:54:52.783Z"},"title":"OLDer"
      };
      tests.createEvent(eventParams, function (err, response) {
        expect(response).not.to.be(undefined);
        testEvent = response;
        done();
      });
  })

  describe('invitees', function () {

      var params = {
        invitees: [{phoneNumber: '8185844837'}, {phoneNumber: '6508621359'}]
      };

    before('sendInvites', function (done) {
      params.eventId = testEvent.objectId;

      //console.log(params);
        tests.sendInvitations(params, function (err, response) {
          expect(err).to.be(null);
          //expect(response.result).to.be("Success");
          done();
        });
    })

      it('should not duplicate text user', function (done) {
            var query = new Parse.Query(Parse.User);
            query.equalTo("phoneNumber", "8185844837");
            query.find({
                success: function (results) {
                    expect(results.length).to.be(1);
                    done();
                },
                error: function (error) {
                    console.log("Error in phoneNumber User query");
                    done();
                }
            });
        });

      it('should not duplicate app user', function(done) {
          var query = new Parse.Query(Parse.User);
          query.equalTo("phoneNumber", "6508621359");
          query.find({
              success: function (results) {
                  expect(results.length).to.be(1);
                  done();
              },
              error: function (error) {
                  console.log("Error in phoneNumber User query");
                  done();
              }
          });
      })

      it('should create 2 new invitations', function(done) {
          var Event = Parse.Object.extend("Event");
          var eventQuery = new Parse.Query(Event);
          eventQuery.equalTo("objectId", testEvent.objectId);

          var Invitation = Parse.Object.extend("Invitation");
          var invitationQuery = new Parse.Query(Invitation);
          invitationQuery.matchesQuery("event", eventQuery);
          //invitationQuery.include("user");

          invitationQuery.find({
              success: function (results) {
                //console.log(JSON.stringify(results)); //results[0].attributes.user);
                  expect(results.length).to.be(2);
                  //expect(results[0].user.phoneNumber).to.be(params.invitees[0].phoneNumber);
                  //expect(results[1].user.phoneNumber).to.be(params.invitees[1].phoneNumber);
                  done();
              },
              error: function (error) {
                  console.log("Error in Invitations query");
                  console.log(error);
                  done();
              }
          });
      })
  });



  after('deletion', function (done) {
    tests.deleteEvent(testEvent.objectId, function (err, response) {
        expect(response).not.to.be(undefined);
        done();
    });
  })
});