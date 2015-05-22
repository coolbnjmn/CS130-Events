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
            var name:String? = locationData["name"] as? String;
            var address:String? = locationData["formatted_address"] as? String;
            var latitude: Double? = locationData.valueForKeyPath("geometry.location.lat") as? Double;
            var longitude: Double? = locationData.valueForKeyPath("geometry.location.lng") as? Double;
            var icon:String? = locationData["icon"] as? String;
            
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