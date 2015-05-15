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
        println(self.searchController?.searchBar.text.lowercaseString)
        let searchText: String? = self.searchController?.searchBar.text.lowercaseString
        let eventTitlePredicate = NSPredicate(format: "eventTitle contains[cd] %@", searchText!)
        let eventLocationPredicate = NSPredicate(format: "eventLocation contains[cd] %@", searchText!)
        let eventDescriptionPredicate = NSPredicate(format: "eventDescription contains[cd] %@", searchText!)
        let cPredicate : NSCompoundPredicate = NSCompoundPredicate.orPredicateWithSubpredicates([eventTitlePredicate, eventLocationPredicate, eventDescriptionPredicate])
        let searchResults: [AnyObject] = self.data!.filteredArrayUsingPredicate(cPredicate)
        
        let nmSearchResults : NSMutableArray = NSMutableArray(array: searchResults)
        
        self.searchResults = nmSearchResults;
    }
    
    

}
