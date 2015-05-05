//
//  ContactModel.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/3/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class ContactModel: BaseModel,  Equatable {
    var name : String!
    var phone : String!
    
    init?(name: String, phone: String) {
        self.name = name
        self.phone = phone
            
    }

}

func ==(lhs: ContactModel, rhs: ContactModel) -> Bool {
    return lhs.phone == rhs.phone
}