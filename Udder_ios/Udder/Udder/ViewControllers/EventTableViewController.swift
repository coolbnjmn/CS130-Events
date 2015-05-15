//
//  EventTableViewController.swift
//  Udder
//
//  Created by Benjamin Hendricks on 4/17/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class EventTableViewController: BaseEventTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.title = "Home"
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
