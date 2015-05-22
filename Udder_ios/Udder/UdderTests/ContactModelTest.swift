//
//  ContactModelTest.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/22/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import XCTest

class ContactModelTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    

    func testEqualityComparison() {
        var contact1 : ContactModel = ContactModel(name: "ABCDEFG", phone: "6501118811")!
        var contact2 : ContactModel = ContactModel(name: "ABCLKDJF", phone: "1112223344")!
        var contact3 : ContactModel = ContactModel(name: "something", phone: "6501118811")!

        XCTAssertFalse(contact1 == contact2, "the phone numbers are different")
        XCTAssertTrue(contact1 == contact3, "the phone numbers are the same")
        XCTAssertFalse(contact2 == contact3, "phone number is different")
    }

}
