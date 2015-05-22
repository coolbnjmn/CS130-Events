//
//  EventSearchProvider.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/14/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class EventSearchProvider: BaseSearchProvider {
   
    override init() {
        super.init()
        self.searchProvider = EventTableViewControllerProvider()
    }
    
    override func applySearch(sender: AnyObject) {
        let searchText: String? = self.searchController?.searchBar.text.lowercaseString
        let eventTitlePredicate = NSPredicate(format: "eventTitle contains[cd] %@", searchText!)
        let eventLocationPredicate = NSPredicate(format: "locationObject.placeLocationName contains[cd] %@", searchText!)
        let eventDescriptionPredicate = NSPredicate(format: "eventDescription contains[cd] %@", searchText!)
        let cPredicate : NSCompoundPredicate = NSCompoundPredicate.orPredicateWithSubpredicates([eventTitlePredicate, eventLocationPredicate, eventDescriptionPredicate])
        
        if let data : NSMutableArray = self.data {
            let searchResults: [AnyObject] = data.filteredArrayUsingPredicate(cPredicate)
            let nmSearchResults : NSMutableArray = NSMutableArray(array: searchResults)
            self.searchResults = nmSearchResults;
        }
        
        
    }
    
    

}
