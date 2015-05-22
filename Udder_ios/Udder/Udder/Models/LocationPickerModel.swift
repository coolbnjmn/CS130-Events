//
//  LocationPickerModel.swift
//  Udder
//
//  Created by Collin Yen on 5/21/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

class LocationPickerModel: BaseModel {
    var manager = AFHTTPRequestOperationManager();
    
    func searchForText(text:String, success: NSMutableArray -> Void, failure: NSError -> Void) {
        var params = [
            "key": Constants.GoogleMaps.kApiKey,
            "query": text
        ];
        
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
