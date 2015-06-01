var parseHeaders = {
  'X-Parse-Application-Id': AppId,
  'X-Parse-REST-API-Key': REST-API-Key
};

var request = require('request');

/***
* Functions to test:
*   1. getAttendees
*   2. sendVerificationCode
*   3. verifyPhoneNumber
*   4. beforeSaveEvent
*   5. sendInvitations
*/


exports.getAttendees = function (params, callback) {
 // console.log(params);
  request({
    url: 'https://api.parse.com/1/functions/getAttendees',
    method: 'POST',
    headers: parseHeaders,
    json: true,
      body: params
  }, function (err, response, body) {
    //console.log(response);
      callback(null, body);
  });
}


exports.sendVerificationCode = function (params, callback) {
 // console.log(params);
  request({
    url: 'https://api.parse.com/1/functions/sendVerificationCode',
    method: 'POST',
    headers: parseHeaders,
    json: true,
      body: params
  }, function (err, response, body) {
    //console.log(response);
      callback(null, body);
  });
}

exports.verifyPhoneNumber = function (params, callback) {
 // console.log(params);
  request({
    url: 'https://api.parse.com/1/functions/verifyPhoneNumber',
    method: 'POST',
    headers: parseHeaders,
    json: true,
      body: params
  }, function (err, response, body) {
    //console.log(response);
      callback(null, body);
  });
}

exports.createEvent = function (params, callback) {
    request({
    url: 'https://api.parse.com/1/classes/Event',
    method: "POST",
    headers: parseHeaders,
    json: true,
      body: params
  }, function (err, response, body) {
    //console.log(response);
      callback(null, body);
  });
}

exports.updateEvent = function (objectId, params, callback) {
    request({
    url: 'https://api.parse.com/1/classes/Event/' + objectId,
    method: "PUT",
    headers: parseHeaders,
    json: true,
      body: params
  }, function (err, response, body) {
    //console.log(response);
      callback(null, body);
  });
}

exports.deleteEvent = function (objectId, callback) {
    request({
    url: 'https://api.parse.com/1/classes/Event/' + objectId,
    method: "DELETE",
    headers: parseHeaders
  }, function (err, response, body) {
    //console.log(response);
      callback(null, body);
  });
}


exports.sendInvitations = function (params, callback) {
    request({
    url: 'https://api.parse.com/1/functions/sendInvitations',
    method: "POST",
    headers: parseHeaders,
    json: true,
      body: params
  }, function (err, response, body) {
    //console.log(response);
      callback(null, body);
  });
}