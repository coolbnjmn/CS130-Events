//
//  EventModelTest.swift
//  Udder
//
//  Created by Collin Yen on 5/26/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import XCTest
import Parse

class EventModelTest: XCTestCase {
    
    let constantTitle : String = "title";
    let constantDescription : String = "description";
    let constantLocation : String = "location";
    let constantAddress : String = "address";
    let constantStartTime : NSDate = NSDate(timeIntervalSinceNow: 0)
    let constantEndTime : NSDate = NSDate(timeIntervalSinceNow: 3600)
    let constantCategory : String = "category"
    let constantImageURL : String = "image";
    let constantCoordinate: PFGeoPoint = PFGeoPoint(latitude: 1, longitude: 2);
    
    let constantInvitationResponse: Bool = false;
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Parse.setApplicationId("sIZN7Eo4sl6tR5ZdI04qIEKf5wm1QJN92jBxTLKb", clientKey: "IfKhgzcCazKuLPJCrQJwhDavQPTX59G0fo91bvuf")
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
        event[Constants.EventDatabaseFields.kEventAddress] = constantAddress;
        event[Constants.EventDatabaseFields.kEventGeoCoordinate] = constantCoordinate;
        event[Constants.EventDatabaseFields.kEventStartTime] = constantStartTime;
        event[Constants.EventDatabaseFields.kEventEndTime] = constantEndTime;
        event[Constants.EventDatabaseFields.kEventCategory] = constantCategory;
        event[Constants.EventDatabaseFields.kEventImageURL] = constantImageURL;
        event[Constants.EventDatabaseFields.kEventHost] = PFUser.currentUser();
        event[Constants.EventDatabaseFields.kEventPrivate] = true;
        
        return event;
    }
    
    func makeTestInvitation() -> PFObject {
        var invitation = PFObject(className: Constants.DatabaseClass.kInvitationClass);
        
        invitation[Constants.InvitationDatabaseFields.kInvitationResponse] = constantInvitationResponse;
        
        return invitation;
    }
    
    func testBasicEventModel() {
        var eventModel:EventModel? = EventModel(eventObject: makeTestEvent());
        
        XCTAssertEqual(constantTitle, eventModel!.eventTitle, "title should match up")
        XCTAssertEqual(constantDescription, eventModel!.eventDescription, "description should match up")
        XCTAssertEqual(constantLocation, eventModel!.locationObject!.placeLocationName, "location should match up")
        XCTAssertEqual(constantAddress, eventModel!.locationObject!.placeAddress!, "address should match up");
        XCTAssertEqual(constantCoordinate, eventModel!.locationObject!.geoPoint!, "geo coordinate should match up");
        XCTAssertEqual(constantStartTime, eventModel!.eventStartTime, "start time should match up")
        XCTAssertEqual(constantEndTime, eventModel!.eventEndTime, "end time should match up")
        XCTAssertEqual(constantCategory, eventModel!.eventCategory, "category should match up")
        XCTAssertEqual(constantImageURL, eventModel!.eventImage, "image should match up")
        XCTAssertEqual(PFUser.currentUser().objectId, eventModel!.eventHost.objectId, "host should match up")
        XCTAssertEqual(true, eventModel!.eventPrivate, "title should match up")
        
    }
    
    func testEventMissingTitle() {
        var eventParseObjectMissingTitle = makeTestEvent();
        eventParseObjectMissingTitle[Constants.EventDatabaseFields.kEventTitle] = NSNull();
        
        var eventModel:EventModel? = EventModel(eventObject: eventParseObjectMissingTitle);
        XCTAssertNil(eventModel, "Event should be nil without title");
    }
    
    func testEventMissingStartTime() {
        var eventParseObjectMissingStartTime = makeTestEvent();
        eventParseObjectMissingStartTime[Constants.EventDatabaseFields.kEventStartTime] = NSNull();

        var eventModel:EventModel? = EventModel(eventObject: eventParseObjectMissingStartTime);
        XCTAssertNil(eventModel, "Event should be nil without start time");
    }
    
    func testEventMissingEndTime() {
        var eventParseObjectMissingEndTime = makeTestEvent();
        eventParseObjectMissingEndTime[Constants.EventDatabaseFields.kEventEndTime] = NSNull();
        
        var eventModel:EventModel? = EventModel(eventObject: eventParseObjectMissingEndTime);
        XCTAssertNil(eventModel, "Event should be nil without end time");
    }
    
    func testEventMissingHost() {
        var eventParseObjectMissingHost = makeTestEvent();
        eventParseObjectMissingHost[Constants.EventDatabaseFields.kEventHost] = NSNull();
        
        var eventModel:EventModel? = EventModel(eventObject: eventParseObjectMissingHost);
        XCTAssertNil(eventModel, "Event should be nil without host");
    }
    
    func testEventWithInvitation() {
        var invitationModel:PFObject = makeTestInvitation();
        var eventModel:EventModel? = EventModel(eventObject: makeTestEvent(), invitation: invitationModel);

        XCTAssertEqual(eventModel!.eventInvitation!.invitationResponse!, constantInvitationResponse, "Invitation response should be true");
        XCTAssertEqual(eventModel!.eventInvitation!.invitationObject!, invitationModel, "Invitation object should be equal to the PFObject it was created with");
    }
}
