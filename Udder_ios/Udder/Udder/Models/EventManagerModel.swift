//
//  EventManagerModel.swift
//  Udder
//
//  Created by Collin Yen on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse

class EventManagerModel: BaseModel {
    let numToReturn = 5;
    class var sharedInstance : EventManagerModel {
        struct EventManager {
            static let instance : EventManagerModel = EventManagerModel()
        }
        return EventManager.instance
    }
    
    func retrieveAllEvents(page: Int, success: NSMutableArray -> Void, failure: NSError -> Void) {
        var query = PFQuery(className: Constants.DatabaseClass.kEventClass);
        
        query.whereKey(Constants.EventDatabaseFields.kEventPrivate, equalTo: false);
        query.limit = numToReturn;
        query.skip = numToReturn*page;
        
        query.orderByAscending(Constants.EventDatabaseFields.kEventStartTime);
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error:NSError!) -> Void in
            self.handleEvents(objects, error: error, success: success, failure: failure);
        }
    }
    
    func retrieveUpcomingEvents(success: NSMutableArray -> Void, failure: NSError -> Void) {
        var query = PFQuery(className: Constants.DatabaseClass.kInvitationClass);
        query.whereKey(Constants.InvitationDatabaseFields.kInvitationUser, equalTo: PFUser.currentUser());
        
        query.includeKey(Constants.InvitationDatabaseFields.kInvitationEvent);
        
        query.findObjectsInBackgroundWithBlock {
            (invitations: [AnyObject]!, error:NSError!) -> Void in
            self.handleInvitations(invitations, error: error, success: success, failure: failure, shouldSort: true);
        }
    }
    
    func retrievePendingInvites(success: NSMutableArray -> Void, failure: NSError -> Void) {
        var query = PFQuery(className: Constants.DatabaseClass.kInvitationClass);
        query.whereKey(Constants.InvitationDatabaseFields.kInvitationUser, equalTo: PFUser.currentUser());
        query.whereKeyDoesNotExist(Constants.InvitationDatabaseFields.kInvitationResponse);
        query.orderByAscending(Constants.InvitationDatabaseFields.kInvitationCreatedAt);
        
        query.includeKey(Constants.InvitationDatabaseFields.kInvitationEvent);
        
        query.findObjectsInBackgroundWithBlock {
            (invitations: [AnyObject]!, error:NSError!) -> Void in
            self.handleInvitations(invitations, error: error, success: success, failure: failure, shouldSort: false);
        }
    }
    
    func retrieveMyEvents(success: NSMutableArray -> Void, failure: NSError -> Void) {
        var query = PFQuery(className: Constants.DatabaseClass.kEventClass);
        query.whereKey(Constants.EventDatabaseFields.kEventHost, equalTo: PFUser.currentUser());
        query.orderByAscending(Constants.EventDatabaseFields.kEventStartTime);
        
        query.findObjectsInBackgroundWithBlock {
            (events: [AnyObject]!, error:NSError!) -> Void in
            self.handleEvents(events, error: error, success: success, failure: failure);
        }
    }

    func retrieveEventsNearMe(miles:Double, success: NSMutableArray -> Void, failure: NSError -> Void) {
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
            if error == nil {
                var query = PFQuery(className: Constants.DatabaseClass.kEventClass);
                query.whereKey(Constants.EventDatabaseFields.kEventPrivate, equalTo: false);
                query.whereKey(Constants.EventDatabaseFields.kEventGeoCoordinate, nearGeoPoint: geoPoint, withinMiles: miles);
                query.findObjectsInBackgroundWithBlock({
                    (events: [AnyObject]!, error: NSError!) -> Void in
                    self.handleEvents(events, error: error, success: success, failure: failure);
                })
            }
            else {
                println("Unable to find current user's location");
                failure(error);
            }
        }
    }
    
    func retrieveAttendeesForEvent(event: EventModel) {
        // TODO: Maybe implement depending on if we can store the attendees in the event model from the query
    }
    
    func createEvent(title:String, description:String, locationObject:PlacesModel, startTime:NSDate, endTime:NSDate, category:String, image:String, isPrivate:Bool, success: EventModel -> Void, failure: NSError -> Void) {
        var event = PFObject(className: Constants.DatabaseClass.kEventClass);
        event[Constants.EventDatabaseFields.kEventTitle] = title;
        event[Constants.EventDatabaseFields.kEventDescription] = description;
        event[Constants.EventDatabaseFields.kEventStartTime] = startTime;
        event[Constants.EventDatabaseFields.kEventEndTime] = endTime;
        event[Constants.EventDatabaseFields.kEventCategory] = category;
        event[Constants.EventDatabaseFields.kEventImageURL] = image;
        event[Constants.EventDatabaseFields.kEventHost] = PFUser.currentUser();
        event[Constants.EventDatabaseFields.kEventPrivate] = isPrivate;
        event[Constants.EventDatabaseFields.kEventLocation] = locationObject.placeLocationName;
        event[Constants.EventDatabaseFields.kEventGeoCoordinate] = locationObject.geoPoint;
        event[Constants.EventDatabaseFields.kEventAddress] = locationObject.placeAddress;
        
        event.saveInBackgroundWithBlock { (isSuccessful, error) -> Void in
            if isSuccessful {
                var eventModel:EventModel? = EventModel(eventObject: event);
                
                if let validatedEventModel = eventModel {
                    success(validatedEventModel);
                }
                else {
                    var error:NSError = NSError(domain: "Unable to generate event model", code: 1, userInfo: nil);
                    failure(error);
                }
            }
            else {
                failure(error);
            }
        }
    }
    
    // Helper Functions
    func sortEventsInDescendingOrder(eventsArray:NSMutableArray) -> NSMutableArray {
        var sortedEvents:NSArray = sorted(eventsArray) {
            (obj1, obj2) in
            let event1 = obj1 as! EventModel;
            let event2 = obj2 as! EventModel;
            return event1.eventStartTime.isEarlierThanDate(event2.eventStartTime);
        }
        
        return NSMutableArray(array: sortedEvents);
    }
    
    // Function handles event data and parses it into event model
    func handleEvents(objects: [AnyObject]!, error:NSError!, success: NSMutableArray -> Void, failure: NSError -> Void) {
        if error == nil {
            var query = PFQuery(className: Constants.DatabaseClass.kInvitationClass);
            query.whereKey(Constants.InvitationDatabaseFields.kInvitationUser, equalTo: PFUser.currentUser());
            
            query.findObjectsInBackgroundWithBlock {
                (invitations: [AnyObject]!, error:NSError!) -> Void in
                if error == nil {
                    if let invitations = invitations as? [PFObject] {
                        if let eventObjects = objects as? [PFObject] {
                            var eventArray:NSMutableArray = self.mergeEventsWithInvitations(eventObjects, invitations: invitations);
                            
                            success(eventArray);
                        }
                        else {
                            println("Error: Shouldn't have gotten to this point: PFObject array not retrieved");
                        }
                    }
                    else {
                        println("Error: Shouldn't have gotten to this point: PFObject array not retrieved");
                    }
                }
                else {
                    // Log details of the error
                    println("Error: \(error) \(error.userInfo!)");
                    failure(error);
                }
            }
        }
        else {
            // Log details of the error
            println("Error: \(error) \(error.userInfo!)");
            failure(error);
        }
    }
    
    // Merges the invitations with events
    func mergeEventsWithInvitations(eventObjects:[PFObject], invitations:[PFObject]) -> NSMutableArray {
        var eventArray:NSMutableArray = NSMutableArray();
        
        for event in eventObjects {
            var eventModel:EventModel? = EventModel(eventObject: event);
            
            // If the event model failed to generate then don't include it in the array
            if let validatedEventModel = eventModel {
                eventArray.addObject(validatedEventModel);
            }
            else {
                println("Failed to validate event");
            }
        }
        
        for invitation in invitations {
            var invitationEvent = invitation["event"] as? PFObject;
            
            if let invitationEvent = invitationEvent {
                for event in eventArray {
                    if let event = event as? EventModel {
                        if invitationEvent.objectId == event.eventObject.objectId {
                            var invitationModel:InvitationModel = InvitationModel(invitation: invitation);
                            event.eventInvitation = invitationModel;
                            break;
                        }
                    }
                }
            }
            else {
                println("Event was not a PFObject");
            }
        }
        
        return eventArray;
    }
    
    // Function handles invitation data and parsing it into events
    func handleInvitations(invitations: [AnyObject]!, error:NSError!, success: NSMutableArray -> Void, failure: NSError -> Void, shouldSort:Bool) {
        if error == nil {
            if let invitations = invitations as? [PFObject] {
                var eventArray:NSMutableArray = NSMutableArray();
                
                for invitation in invitations {
                    var event = invitation["event"] as? PFObject;
                    
                    if let event = event {
                        var eventModel:EventModel? = EventModel(eventObject: event, invitation:invitation);
                        
                        // If the event model failed to generate then don't include it in the array
                        if let validatedEventModel = eventModel {
                            eventArray.addObject(validatedEventModel);
                        }
                        else {
                            println("Event did not validate");
                        }
                    }
                    else {
                        println("Event was not a PFObject");
                    }
                }
                
                if shouldSort {
                    eventArray = self.sortEventsInDescendingOrder(eventArray);
                }
                success(eventArray);
            }
            else {
                println("Error: Shouldn't have gotten to this point: PFObject array not retrieved");
            }
        }
        else {
            // Log details of the error
            println("Error: \(error) \(error.userInfo!)");
            failure(error);
        }
    }
}
