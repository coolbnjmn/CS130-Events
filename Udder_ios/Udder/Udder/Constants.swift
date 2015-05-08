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
        static let kEventClass = "Event"
    }
    
    struct EventDatabaseFields {
        static let kEventTitle = "title"
        static let kEventDescription = "description"
        static let kEventLocation = "location"
        static let kEventLatitude = "latitude"
        static let kEventLongitude = "longitude"
        static let kEventStartTime = "start_time"
        static let kEventEndTime = "end_time"
        static let kEventImageURL = "image_url"
        static let kEventHost = "host"
        static let kEventCategory = "category"
        static let kEventPrivate = "private"
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
            static let kDescriptionTextFont = "Avenir-Medium"
            static let kDefaultMargin:CGFloat = 8;
        }
    }
    
    struct DateFormats {
        static let kFullDateFormat = "EEE, MMM d, YYYY h:mm a "
        static let kDateFormat = "EEEE, MMM d, YYYY"
        static let kShortWeekDateFormat = "EEE, MMM d, YYYY"
        static let kTimeFormat = "h:mm a"
        static let kDayOfWeekFormat = "EEEE"
    }
    
    struct StandardFormats {
        static let kStandardTextFont = "Avenir-Heavy";
        static let kStandardEventsTextFont = "Avenir-Book";
        static let kNavTitleFontSize: CGFloat = 25.0
        static let kSideBarNavNameFontSize: CGFloat = 20.0
    }
    
    struct PlaceHolders {
        static let EventImage:UIImage = UIImage(named: "Beach.jpg")!
    }
    
    struct Colors {
        static let ThemeColor:UIColor = UIColor(red: 86/255, green: 206/255, blue: 106/255, alpha: 1.0)
    }
    
    struct Images {
        static let NavBarIcon: UIImage! = UIImage(named: "icon-menu.png")
        static let PlusIcon: UIImage! = UIImage(named: "icon-plus.png")
    }

    struct EventCategories {
        static let kFitnessCategory = "Fitness";
        static let kFoodCategory = "Food";
        static let kEntertainmentCategory = "Entertainment";
        static let kMusicCategory = "Music";
        static let kAcademicCategory = "Academic";
        static let kOtherCategory = "Other"
    }
    
    static let EventCategoryImageMap = [
        EventCategories.kFitnessCategory: "category-fitness.png",
        EventCategories.kFoodCategory: "category-food.png",
        EventCategories.kEntertainmentCategory: "category-entertainment.png",
        EventCategories.kMusicCategory: "category-music.png",
        EventCategories.kAcademicCategory: "category-academic.png",
        EventCategories.kOtherCategory: "category-other.png"
    ]
}