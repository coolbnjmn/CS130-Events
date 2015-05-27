//
//  PlacesModel.swift
//  Udder
//
//  Created by shai segal on 5/14/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import Parse

class PlacesModel: BaseModel /*,  Equatable*/ {
    var placeAddress:String?
    var placeLocationName:String!
    var placeIcon:String?
    var geoPoint:PFGeoPoint?
    
    init(address:String?, geoPoint:PFGeoPoint?, locationName:String) {
        self.placeAddress = address;
        self.placeLocationName = locationName;
        self.geoPoint = geoPoint;
    }
    
    init?(object:AnyObject!) {
        super.init();
        
        if let locationData:NSDictionary = object as? NSDictionary {
            var name:String? = locationData[Constants.GoogleLocationKeys.kName] as? String;
            var address:String? = locationData[Constants.GoogleLocationKeys.kAddress] as? String;
            var latitude: Double? = locationData.valueForKeyPath(Constants.GoogleLocationKeys.kLatitude) as? Double;
            var longitude: Double? = locationData.valueForKeyPath(Constants.GoogleLocationKeys.kLongitude) as? Double;
            var icon:String? = locationData[Constants.GoogleLocationKeys.kIcon] as? String;
            
            if let name = name {
                self.placeLocationName = name;
                self.placeAddress = address;
                self.placeIcon = icon;
                
                if let latitude = latitude {
                    if let longitude = longitude {
                         self.geoPoint = PFGeoPoint(latitude: latitude, longitude: longitude);
                    }
                }
            }
            else {
                println("No name found");
                return nil;
            }
        }
        else {
            return nil;
        }
    }
}