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
        static let kDescriptionTableViewCell = "DescriptionTableViewCell"
        static let kLocationTableViewCell = "LocationTableViewCell"
        static let kTimeInfoTableViewCell = "TimeInfoTableViewCell"
        static let kStandardTableViewCell = "StandardTableViewCell"
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
    
    struct EventDetail {
        struct Row {
            static let kDescriptionCell = 2;
            static let kTimeCell = 0;
            static let kLocationCell = 1;
        }
        
        struct TableConstraints {
            static let kDescriptionViewHeight:CGFloat = 150;
            static let kDescriptionTextSize:CGFloat = 14;
            static let kDescriptionTextFont = "Avenir-Book"
            static let kDefaultMargin:CGFloat = 8;
        }
    }
    
    struct DateFormats {
        static let kFullDateFormat = "EEE, MMM d, YYYY h:mm a "
        static let kDateFormat = "EEEE, MMM d, YYYY"
        static let kShortWeekDateFormat = "EEE, MMM d, YYYY"
        static let kTimeFormat = "hh:mm a"
        static let kDayOfWeekFormat = "EEEE"
    }
    
    struct StandardFormats {
        static let kStandardTextFont = "Avenir-Book";
    }    
}