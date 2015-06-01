var expect = require('expect.js');
var tests = require('./tests.js');

describe('Event', function () {
  var testEvent = {};
  before('creation', function (done) {
      var params = {
        "address":"Los Angeles, CA, USA","category":"Fitness","description":"desc","end_time":{"__type":"Date","iso":"2015-05-31T03:55:20.000Z"},"geocoordinate":{"__type":"GeoPoint","latitude":34.0522342,"longitude":-118.2436849},"host":{"__type":"Pointer","className":"_User","objectId":"jAEDkEzDLR"},"image_url":"","location":"Los Angeles","private":false,"start_time":{"__type":"Date","iso":"2015-05-28T03:54:52.783Z"},"title":"OLD"
      };
      tests.createEvent(params, function (err, response) {
        expect(response).not.to.be(undefined);
        testEvent = response;
        done();
      });
  })

  describe('updates', function () {
      it('should update the image_url when the title changes', function (done) {
        var update_params = {"title": "NEW"}
        tests.updateEvent(testEvent.objectId, update_params, function (err, response) {
          expect(response.title).not.to.be(testEvent.title);
          expect(response.image_url).not.to.be(testEvent.image_url);
          done();
        })
      });
      it('should not update the image_url when the title does not change', function (done) {
        var update_params = {"description": "NEW"}
        tests.updateEvent(testEvent.objectId, update_params, function (err, response) {
          // only updated parameters are included in the response, 
          // thus we expected the image_url key to be undefined since it wasn't updated.
          expect(response.image_url).to.be(undefined);
          done();
        })
      });
    });

  after('deletion', function (done) {
    tests.deleteEvent(testEvent.objectId, function (err, response) {
        expect(response).not.to.be(undefined);
        done();
    });
  })
  
});