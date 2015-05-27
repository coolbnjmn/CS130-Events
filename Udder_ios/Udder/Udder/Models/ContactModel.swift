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
    var fbid: String!
    var isInPhonebook: Bool!
    var isFBFriend: Bool!
    
    init?(name: String, phone: String, fb: String = "", inPhoneBook: Bool = false, fbFriend: Bool = false) {
        self.name = name
        self.phone = phone
        self.fbid = fb
        self.isInPhonebook = inPhoneBook
        self.isFBFriend = fbFriend
    }
    
}

func ==(lhs: ContactModel, rhs: ContactModel) -> Bool {
    return lhs.phone == rhs.phone
}