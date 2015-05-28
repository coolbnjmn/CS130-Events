//
//  MyEventsViewController.swift
//  Udder
//
//  Created by Ari Ekmekji on 4/24/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class MyEventsViewController: BaseEventTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "My Events"
    }
    
    override func fetchData() {
        eventManagerModel.retrieveMyEvents(0, success:self.successBlock, failure: self.failureBlock);
    }
    
    override func loadMoreData(page: Int, success: NSMutableArray -> Void, failure: NSError -> Void) {
        eventManagerModel.retrieveMyEvents(page, success: success, failure: failure);
    }
}

