//
//  EventsNearMeViewController.swift
//  Udder
//
//  Created by Ari Ekmekji on 4/24/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class EventsNearMeViewController: BaseEventTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Events Near Me"
    }
    
    override func fetchData() {
        self.eventManagerModel.retrieveEventsNearMe(10.0, success: self.successBlock, failure: self.failureBlock);
    }
}
