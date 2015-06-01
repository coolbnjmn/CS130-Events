var expect = require('expect.js');
var tests = require('./tests.js');

describe('getAttendees', function () {
  describe('response', function () {
      it('should return an array of attendees for valid eventId', function (done) {
          var params = {
            eventId: 'vtTjqX8grA'
          };
          tests.getAttendees(params, function (err, response) {
            //console.log(response);
            expect(response.result.length).to.be(5);
            done();
          });
      });
      it('should return an empty array of attendees with a bad eventId', function(done) {
          var params = {
            eventId: 'blah'
          };
          tests.getAttendees(params, function(err, response) {
            expect(response.result.length).to.be(0);
            done();
          });
      });
  });
});