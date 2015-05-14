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
    var add:String
    var lat:Double
    var long:Double
    var location:CLLocation
    
    init?(add:String, lat:Double, long:Double) {
        self.add = add
        self.lat = lat
        self.long = long
        self.location = CLLocation(latitude: self.lat,longitude: self.long)
        
    }
    
    func get_add () -> String{
        return add
    }
    
}

/*func ==(lhs: ContactModel, rhs: ContactModel) -> Bool {
    return lhs.phone == rhs.phone
}*/