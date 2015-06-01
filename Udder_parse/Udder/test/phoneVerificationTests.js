var expect = require('expect.js');
var tests = require('./tests.js');

var Parse = require("parse").Parse;
Parse.initialize("key 1", "key 2");



describe('sendVerificationCode', function () {
  describe('texting', function () {
      it('should send a text to a valid phone number', function (done) {
          var params = {
            phoneNumber: '8185844837',
            testUser: true
          };
          tests.sendVerificationCode(params, function (err, response) {
            expect(response.result).to.be("Success");
            done();
          });
      });
      it('should fail to send a text with an invalid phone number', function(done) {
          var params = {
            phoneNumber: 'blah',
            testUser: true
          };
          tests.sendVerificationCode(params, function(err, response) {
            expect(response.result).to.be(undefined);
            done();
          });
      });
  });
});

describe('verifyPhoneNumber', function () {
  describe('verification', function () {
      it('should verify the phone number if the verification code is correct', function (done) {
          var params = {
            phoneVerificationCode: '123456',
            testUser: true
          };
          tests.verifyPhoneNumber(params, function (err, response) {
            expect(response.result).to.be("Success");
            done();
          });
      });
      it('should fail to verify the phone number if the verification code is incorrect', function(done) {
          var params = {
            phoneVerificationCode: '654321',
            testUser: true
          };
          tests.verifyPhoneNumber(params, function(err, response) {
            //console.log(response);
            expect(response.error).to.be("Invalid verification code.");
            done();
          });
      });
  });
});
