
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


// This will become an afterSave trigger in the final version
// i.e. Parse.Cloud.afterSave("Event", function(request) {
// UPDATE: Maybe not, since we need to send a response. 
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