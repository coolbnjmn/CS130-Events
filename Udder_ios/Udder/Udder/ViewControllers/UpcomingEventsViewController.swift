//
//  UpcomingEventsViewController.swift
//  Udder
//
//  Created by Ari Ekmekji on 4/24/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class UpcomingEventsViewController: BaseEventTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Upcoming Events"
    }
    
    override func fetchData() {
        var successBlock: NSMutableArray -> Void = {
            (eventArray: NSMutableArray) -> Void in
            self.eventTableViewControllerProvider.configure(eventArray);
            self.eventSearchProvider.configure(eventArray, provider:self.eventTableViewControllerProvider);
            self.eventSearchProvider.delegate = self

            self.tableView.reloadData();
        }
        
        var failureBlock: NSError -> Void = {
            (error: NSError) -> Void in
            println("Error: \(error)");
        }
        
        eventManagerModel.retrieveUpcomingEvents(successBlock, failure: failureBlock);
    }
}
