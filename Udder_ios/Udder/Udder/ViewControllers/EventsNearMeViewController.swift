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
        self.eventManagerModel.retrieveEventsNearMe(0, miles: 20.0, success: self.successBlock, failure: self.failureBlock);
    }
    
    override func loadMoreData(page: Int, success: NSMutableArray -> Void, failure: NSError -> Void) {
        self.eventManagerModel.retrieveEventsNearMe(page, miles: 20.0, success: success, failure: failure);
    }
}
