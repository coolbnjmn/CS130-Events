//
//  EventModel.swift
//  Udder
//
//  Created by Collin Yen on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import Foundation
import Parse

class EventModel: BaseModel {
    var eventId: String!;
    var eventTitle: String!;
    var eventDescription: String!;
    var eventLocation: String!;
    var eventLatitude: Float?;
    var eventLongitude: Float?;
    var eventStartTime: NSDate!;
    var eventEndTime: NSDate!;
    var formattedStartTime: String!;
    var formattedEndTime: String!;
    var eventImage: String!;
    
    init?(eventObject: PFObject) {
        super.init();
        
        self.eventId = eventObject.objectId;
        
        if let tempTitle = eventObject[Constants.EventDatabaseFields.kEventTitle] as? String {
            self.eventTitle = tempTitle;
        }
        
        self.eventLocation = eventObject[Constants.EventDatabaseFields.kEventLocation] as? String ??
            Constants.EventDatabaseFields.kEventFieldPlaceholder;
        
        self.eventDescription = eventObject[Constants.EventDatabaseFields.kEventDescription] as? String ??
            Constants.EventDatabaseFields.kEventFieldPlaceholder;
        
        self.eventImage = eventObject[Constants.EventDatabaseFields.kEventImageIURL] as? String ??
            Constants.EventDatabaseFields.kEventFieldPlaceholder;
        
        if let tempStartTime = eventObject[Constants.EventDatabaseFields.kEventStartTime] as? NSDate {
            self.eventStartTime = tempStartTime;
        }
        
        // TODO: Set default event end time to one hour
        if let tempEventTime = eventObject[Constants.EventDatabaseFields.kEventEndTime] as? NSDate {
            self.eventEndTime = tempEventTime;
        }
        
        self.eventLatitude = eventObject[Constants.EventDatabaseFields.kEventLatitude] as? Float;
        self.eventLongitude = eventObject[Constants.EventDatabaseFields.kEventLongitude] as? Float;
        
        // Check to make sure all required fields are set
        if (self.eventTitle == nil || self.eventStartTime == nil || self.eventEndTime == nil) {
            return nil;
        }
    }
    
    func printEvent() {
        println("Event ID: \(self.eventId)");
        println("Title: \(self.eventTitle)");
        println("Location: \(self.eventLocation)");
        println("Description: \(self.eventDescription)");
        println("Image: \(self.eventImage)");
        println("Start Time: \(self.eventStartTime)");
        
        if let latitude = self.eventLatitude {
            println("Latitude: \(latitude)");
        }
        
        if let longitude = self.eventLongitude {
            println("Longitude: \(longitude)");
        }
    }
}