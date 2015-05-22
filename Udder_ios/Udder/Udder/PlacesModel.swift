//
//  PlacesModel.swift
//  Udder
//
//  Created by shai segal on 5/14/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import Foundation
import UIKit

class PlacesModel: BaseModel /*,  Equatable*/ {
    var placeAddress:String?
    var placeLatitude:Double?
    var placeLongitude:Double?
    var placeLocationName:String!
    var placeIcon:String?
    
    init(address:String, latitude:Double, longitude:Double, locationName:String) {
        self.placeAddress = address;
        self.placeLatitude = latitude;
        self.placeLongitude = longitude;
        self.placeLocationName = locationName;
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
                self.placeLongitude = longitude;
                self.placeLatitude = latitude;
                self.placeIcon = icon;
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