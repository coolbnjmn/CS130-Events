//
//  PendingInvitationsViewController.swift
//  Udder
//
//  Created by Ari Ekmekji on 4/24/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class PendingInvitationsViewController: BaseEventTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Pending Invites"
    }

    override func fetchData() {
        eventManagerModel.retrievePendingInvites(0, success: self.successBlock, failure: self.failureBlock);
    }
    
    override func loadMoreData(page: Int, success: NSMutableArray -> Void, failure: NSError -> Void) {
        eventManagerModel.retrievePendingInvites(page, success: success, failure: failure);
    }
}
