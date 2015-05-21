//
//  EventTableViewCellTest.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/21/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import XCTest

import Parse

class EventTableViewCellTest: XCTestCase {

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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEventModel() {
//        let testEventModel : EventModel = EventModel();
        
        let constantTitle : String = "title";
        let constantDescription : String = "description";
        let constantLocation : String = "location";
        let constantStartTime : NSDate = NSDate(timeIntervalSinceNow: 0)
        let constantEndTime : NSDate = NSDate(timeIntervalSinceNow: 3600)
        let constantCategory : String = "category"
        let constantImageURL : String = "image";
        
        Parse.setApplicationId("sIZN7Eo4sl6tR5ZdI04qIEKf5wm1QJN92jBxTLKb", clientKey: "IfKhgzcCazKuLPJCrQJwhDavQPTX59G0fo91bvuf")

        var event = PFObject(className: Constants.DatabaseClass.kEventClass);
        event[Constants.EventDatabaseFields.kEventTitle] = constantTitle;
        event[Constants.EventDatabaseFields.kEventDescription] = constantDescription;
        event[Constants.EventDatabaseFields.kEventLocation] = constantLocation;
        event[Constants.EventDatabaseFields.kEventStartTime] = constantStartTime;
        event[Constants.EventDatabaseFields.kEventEndTime] = constantEndTime;
        event[Constants.EventDatabaseFields.kEventCategory] = constantCategory;
        event[Constants.EventDatabaseFields.kEventImageURL] = constantImageURL;
        event[Constants.EventDatabaseFields.kEventHost] = PFUser.currentUser();
        event[Constants.EventDatabaseFields.kEventPrivate] = true;
        
        var eventModel:EventModel? = EventModel(eventObject: event);

        
        XCTAssertEqual(constantTitle, eventModel!.eventTitle, "title should match up")
    }

}
