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

    let constantTitle : String = "title";
    let constantDescription : String = "description";
    let constantLocation : String = "location";
    let constantStartTime : NSDate = NSDate(timeIntervalSinceNow: 0)
    let constantEndTime : NSDate = NSDate(timeIntervalSinceNow: 3600)
    let constantCategory : String = "category"
    let constantImageURL : String = "image";
    
    
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
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
    }
    
    func makeTestEvent() -> PFObject {
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
        return event;
    }
    
    func testBasicEventModel() {
        Parse.setApplicationId("sIZN7Eo4sl6tR5ZdI04qIEKf5wm1QJN92jBxTLKb", clientKey: "IfKhgzcCazKuLPJCrQJwhDavQPTX59G0fo91bvuf")

        var eventModel:EventModel? = EventModel(eventObject: makeTestEvent());

        
        XCTAssertEqual(constantTitle, eventModel!.eventTitle, "title should match up")
        XCTAssertEqual(constantDescription, eventModel!.eventDescription, "description should match up")
        XCTAssertEqual(constantLocation, eventModel!.eventLocation, "location should match up")
        XCTAssertEqual(constantStartTime, eventModel!.eventStartTime, "start time should match up")
        XCTAssertEqual(constantEndTime, eventModel!.eventEndTime, "end time should match up")
        XCTAssertEqual(constantCategory, eventModel!.eventCategory, "category should match up")
        XCTAssertEqual(constantImageURL, eventModel!.eventImage, "image should match up")
        XCTAssertEqual(PFUser.currentUser().objectId, eventModel!.eventHost.objectId, "host should match up")
        XCTAssertEqual(true, eventModel!.eventPrivate, "title should match up")

    }
    
    func testEventCellLayoutBasic() {
        Parse.setApplicationId("sIZN7Eo4sl6tR5ZdI04qIEKf5wm1QJN92jBxTLKb", clientKey: "IfKhgzcCazKuLPJCrQJwhDavQPTX59G0fo91bvuf")
        
        var eventModel:EventModel? = EventModel(eventObject: makeTestEvent());
        var cell: UITableViewCell = UITableViewCell()
        XCTAssertLessThanOrEqual(cell.textLabel!.frame.size.width, cell.frame.size.width, "text label width should be less than cell's frame")
    }
    
    

}
