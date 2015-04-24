//
//  Constants.swift
//  Udder
//
//  Created by Benjamin Hendricks on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

struct Constants {
    struct CellIdentifiers {
        static let kEventTitleCell = "kEventViewTitleCell"
    }
    
    struct DatabaseClass {
        static let kEventClass = "EventTest"
    }
    
    struct EventDatabaseFields {
        static let kEventTitle = "title"
        static let kEventDescription = "description"
        static let kEventLocation = "location"
        static let kEventLatitude = "latitude"
        static let kEventLongitude = "longitude"
        static let kEventStartTime = "start_time"
        static let kEventEndTime = "end_time"
        static let kEventImageIURL = "image_url"
        static let kEventFieldPlaceholder = ""
    }
}