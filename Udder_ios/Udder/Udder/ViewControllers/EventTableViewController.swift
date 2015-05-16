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
        eventManagerModel.retrieveAllEvents(self.successBlock, failure: self.failureBlock);
    }
}
