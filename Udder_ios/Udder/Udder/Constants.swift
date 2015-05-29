//
//  Constants.swift
//  Udder
//
//  Created by Benjamin Hendricks on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//
import UIKit

struct Constants {
    struct CellIdentifiers {
        static let kEventTitleCell = "kEventViewTitleCell"
        static let kDescriptionTableViewCell = "DescriptionTableViewCell"
        static let kLocationTableViewCell = "LocationTableViewCell"
        static let kTimeInfoTableViewCell = "TimeInfoTableViewCell"
        static let kStandardTableViewCell = "StandardTableViewCell"
        static let kAttendeesTableViewCell = "AttendeesTableViewCell"
        static let kLocationPickerTableViewCell = "LocationPickerTableViewCell"
    }
    
    struct DatabaseClass {
        static let kEventClass = "Event"
        static let kInvitationClass = "Invitation"
    }
    
    struct DatabasePagination {
        static let kNumberEventsToReturn = 25;
    }
    
    struct EventDatabaseFields {
        static let kEventTitle = "title"
        static let kEventDescription = "description"
        static let kEventLocation = "location"
        static let kEventGeoCoordinate = "geocoordinate"
        static let kEventAddress = "address"
        static let kEventStartTime = "start_time"
        static let kEventEndTime = "end_time"
        static let kEventImageURL = "image_url"
        static let kEventHost = "host"
        static let kEventCategory = "category"
        static let kEventPrivate = "private"
        static let kEventFieldPlaceholder = ""
    }
    
    struct InvitationDatabaseFields {
        static let kInvitationUser = "user"
        static let kInvitationResponse = "response"
        static let kInvitationEvent = "event"
        static let kInvitationCreatedAt = "createdAt"
    }
    
    struct EventDetail {
        struct Row {
            static let kDescriptionCell = 2;
            static let kTimeCell = 0;
            static let kLocationCell = 1;
        }
        
        struct TableConstraints {
            static let kDescriptionViewHeight: CGFloat = 150;
            static let kDescriptionTextSize: CGFloat = 14;
            static let kDescriptionTextFont = "Avenir-Medium"
            static let kDefaultMargin: CGFloat = 8;
            static let kAttendeeTextFont = "Avenir-Book"
            static let kAttendeeTextSize: CGFloat = 18.0
            static let kAttendeeCellHeight: CGFloat = 55.0
            static let kEventCreationDescriptionCellHeight:CGFloat = 100.0
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
        static let kStandardTextFont = "Avenir-Medium";
        static let kStandardEventsTextFont = "Avenir-Book";
        static let kNavTitleFontSize: CGFloat = 22.0
        static let kSideBarNavNameFontSize: CGFloat = 20.0
        static let kButtonTextFont = "Avenir-Book"
        static let kButtonTextFontSize: CGFloat = 20.0
        static let kImageSelectionCellHeight: CGFloat = 200.0
    }
    
    struct PlaceHolders {
        static let EventImage: UIImage = UIImage(named: "Beach.jpg")!
        static let LocationImage: UIImage = UIImage(named: "Beach.jpg")!
        static let AttendeeImage: UIImage = UIImage(named: "user-default.png")!
    }
    
    struct Colors {
        static let ThemeColor:UIColor = UIColor(red: 86/255, green: 206/255, blue: 106/255, alpha: 1.0)
        static let BackgroundGrayColor:UIColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    }
    
    struct Images {
        static let NavBarIcon: UIImage! = UIImage(named: "icon-menu.png")
        static let PlusIcon: UIImage! = UIImage(named: "icon-plus.png")
        static let FbLogo: UIImage! = UIImage(named: "icon-fb.png")
        static let ContactLogo: UIImage! = UIImage(named: "icon-contact.png")
        static let SelfLogo: UIImage! = UIImage(named: "icon-user.png")
        static let PrivateBanner: UIImage! = UIImage(named: "private-banner.png")
        static let SuccessAlertIcon: UIImage! = UIImage(named: "Beach.jpg");
        static let FailureAlertIcon: UIImage! = UIImage(named: "icon-menu.png")
    }

    // TODO: Add a category for Social
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
    
    // Google Maps Constants
    struct GoogleMaps {
        static let kUrl = "https://maps.googleapis.com/maps/api/place/textsearch/json";
        static let kApiKey = "AIzaSyBYOIc_oRgl8ridepQWCR3mG9IkfEODe8A";
    }
    
    struct GoogleLocationKeys {
        static let kName = "name";
        static let kAddress = "formatted_address";
        static let kIcon = "icon";
        static let kLatitude = "geometry.location.lat";
        static let kLongitude = "geometry.location.lng";
    }
    
    struct PushTypes {
        static let kNewInvitationType = "newInvitation";
    }
}