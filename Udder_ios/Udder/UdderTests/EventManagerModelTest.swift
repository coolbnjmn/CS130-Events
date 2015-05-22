//
//  EventManagerModelTest.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/21/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import XCTest

import Parse


class EventManagerModelTest: XCTestCase {

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

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testSingletonReturnsInstance() {
        XCTAssertNotNil(EventManagerModel.sharedInstance, "singleton should never be null");
    }

    func makeTestEventForString(string: String) -> PFObject {
        var event = PFObject(className: Constants.DatabaseClass.kEventClass);
        event[Constants.EventDatabaseFields.kEventTitle] = string;
        event[Constants.EventDatabaseFields.kEventDescription] = string;
        event[Constants.EventDatabaseFields.kEventLocation] = string;
        event[Constants.EventDatabaseFields.kEventStartTime] = NSDate(timeIntervalSinceNow: 0);
        event[Constants.EventDatabaseFields.kEventEndTime] = NSDate(timeIntervalSinceNow: 3600);
        event[Constants.EventDatabaseFields.kEventCategory] = string;
        event[Constants.EventDatabaseFields.kEventImageURL] = string;
        event[Constants.EventDatabaseFields.kEventHost] = PFUser.currentUser();
        event[Constants.EventDatabaseFields.kEventPrivate] = true;
        return event;
    }
    
    func makeTestInvitationForString(string: String) -> PFObject {
        var invitation = PFObject(className: Constants.DatabaseClass.kInvitationClass);
        invitation[Constants.InvitationDatabaseFields.kInvitationResponse] = string;
        invitation[Constants.InvitationDatabaseFields.kInvitationUser] = string;
        return invitation;
    }
    
    
    func testHandleEvents() {
        Parse.setApplicationId("sIZN7Eo4sl6tR5ZdI04qIEKf5wm1QJN92jBxTLKb", clientKey: "IfKhgzcCazKuLPJCrQJwhDavQPTX59G0fo91bvuf")

        var eventArray : NSMutableArray = NSMutableArray()
        for var i = 0; i < 10; i++ {
            eventArray.addObject(makeTestEventForString("This is item: \(i)"))
        }
        
        EventManagerModel.sharedInstance.handleEvents(eventArray as [AnyObject], error: nil, success: {
            (eventArray: NSMutableArray) -> Void in
            XCTAssertTrue(true, "success block means handleEvents succeeded");
            }, failure: {
                (error: NSError) -> Void in
                println("Error: \(error)");
                XCTAssertTrue(false, "failure block means error: \(error)");
                
        });
        
    }

    func testHandleInvitations() {
        Parse.setApplicationId("sIZN7Eo4sl6tR5ZdI04qIEKf5wm1QJN92jBxTLKb", clientKey: "IfKhgzcCazKuLPJCrQJwhDavQPTX59G0fo91bvuf")
        
        var inviteArray : NSMutableArray = NSMutableArray()
        for var i = 0; i < 10; i++ {
            inviteArray.addObject(makeTestInvitationForString("This is item: \(i)"))
        }
        
        EventManagerModel.sharedInstance.handleInvitations(inviteArray as [AnyObject], error: nil, success: {
            (eventArray: NSMutableArray) -> Void in
            XCTAssertTrue(true, "success block means handleInvites succeeded");
            }, failure: {
                (error: NSError) -> Void in
                println("Error: \(error)");
                XCTAssertTrue(false, "failure block means error: \(error)");
                
        }, shouldSort: true);
    }

}
