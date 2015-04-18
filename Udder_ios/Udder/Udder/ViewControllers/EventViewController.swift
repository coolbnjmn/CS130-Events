//
//  EventViewController.swift
//  Udder
//
//  Created by Collin Yen on 4/17/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        let titleViewNib:UINib = UINib(nibName: "EventViewTitleCell", bundle: nil);
        self.tableView.registerNib(titleViewNib, forCellReuseIdentifier: Constants.CellIdentifiers.kEventTitleCell);
        
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        self.edgesForExtendedLayout = UIRectEdge.None;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kEventTitleCell, forIndexPath: indexPath) as EventViewTitleCell;
        
        return cell;
    }
}
