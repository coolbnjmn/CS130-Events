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
        eventManagerModel.retrieveUpcomingEvents(self.successBlock, failure: self.failureBlock);
    }
}
