//
//  LocationPickerModel.swift
//  Udder
//
//  Created by Collin Yen on 5/21/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import Parse

class LocationPickerModel: BaseModel {
    var manager = AFHTTPRequestOperationManager();
    var currentLocation:PFGeoPoint?;
    
    override init() {
        super.init();
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
            if error == nil {
                self.currentLocation = geoPoint;
            }
            else {
                println("Unable to retrieve user's location");
            }
        }
    }
    
    func searchForText(text:String, success: NSMutableArray -> Void, failure: NSError -> Void) {
        var params = [
            "key": Constants.GoogleMaps.kApiKey,
            "query": text
        ];
        
        if let location = self.currentLocation {
            params["location"] = "\(location.latitude), \(location.longitude)";
            params["radius"] = "50000";
        }
        
        manager.GET(Constants.GoogleMaps.kUrl, parameters: params, success: { (operation, responseObject) -> Void in
            
            var locations:NSMutableArray = NSMutableArray();
            var responseData:NSDictionary = responseObject as! NSDictionary;
            var locationsArray:NSArray = responseData["results"] as! NSArray;
            for location in locationsArray {
                var placesModel:PlacesModel? = PlacesModel(object: location);
                if let placesModel = placesModel {
                    locations.addObject(placesModel);
                }
                else {
                    println("Failed to validate location data");
                }
            }
            
            success(locations);
            
        }) { (operation, error) -> Void in
            failure(error);
        }
    }
}
