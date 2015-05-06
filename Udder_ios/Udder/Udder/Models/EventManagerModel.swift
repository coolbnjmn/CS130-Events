//
//  EventManagerModel.swift
//  Udder
//
//  Created by Collin Yen on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import Parse

class EventManagerModel: BaseModel {
    // TODO: Have this actually retrieve upcoming events
    func retrieveUpcomingEvents(success: NSMutableArray -> Void, failure: NSError -> Void) {
        var query = PFQuery(className: Constants.DatabaseClass.kEventClass);
        query.orderByDescending(Constants.EventDatabaseFields.kEventStartTime);
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                if let eventObjects = objects as? [PFObject] {
                    var eventArray:NSMutableArray = NSMutableArray();
                    
                    for event in eventObjects {
                        var eventModel:EventModel? = EventModel(eventObject: event);
                        
                        // If the event model failed to generate then don't include it in the array
                        if let validatedEventModel = eventModel {
                            eventArray.addObject(validatedEventModel);
                        }
                        else {
                            println("Event did not validate");
                        }
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
    
    func retrieveMyEvents(success: NSMutableArray -> Void, failure: NSError -> Void) {
        // TODO: Implement
    }
    
    func retrieveNearbyEvents(success: NSMutableArray -> Void, failure: NSError -> Void) {
        // TODO: Implement
    }
    
    func retrieveAttendeesForEvent(event: EventModel) {
        // TODO: Maybe implement depending on if we can store the attendees in the event model from the query
    }
    
    func createEvent(title:String, description:String, location:String, startTime:NSDate, endTime:NSDate, category:String, image:String, isPrivate:Bool, success: EventModel -> Void, failure: NSError -> Void) {
        var event = PFObject(className: Constants.DatabaseClass.kEventClass);
        event[Constants.EventDatabaseFields.kEventTitle] = title;
        event[Constants.EventDatabaseFields.kEventDescription] = description;
        event[Constants.EventDatabaseFields.kEventLocation] = location;
        event[Constants.EventDatabaseFields.kEventStartTime] = startTime;
        event[Constants.EventDatabaseFields.kEventEndTime] = endTime;
        event[Constants.EventDatabaseFields.kEventCategory] = category;
        event[Constants.EventDatabaseFields.kEventImageURL] = image;
        event[Constants.EventDatabaseFields.kEventHost] = PFUser.currentUser();
        event[Constants.EventDatabaseFields.kEventPrivate] = isPrivate;
        
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
}
