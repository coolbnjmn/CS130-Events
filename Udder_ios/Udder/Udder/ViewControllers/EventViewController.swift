//
//  EventViewController.swift
//  Udder
//
//  Created by Collin Yen on 4/17/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

struct Segment {
    static let kSegmentInfo = 0;
    static let kSegmentAttendees = 1;
}

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var attendeesTableView: UITableView!
    
    
    var segmentSelected = Segment.kSegmentInfo;
    
    override func viewDidLoad() {
        let titleViewNib:UINib = UINib(nibName: "EventViewTitleCell", bundle: nil);
        self.infoTableView.registerNib(titleViewNib, forCellReuseIdentifier: Constants.CellIdentifiers.kEventTitleCell);
        
        self.infoTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        self.edgesForExtendedLayout = UIRectEdge.None;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kEventTitleCell, forIndexPath: indexPath) as EventViewTitleCell;
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("Identifier", forIndexPath: indexPath) as UITableViewCell;
        let cell = UITableViewCell();
        
        if  (tableView == self.infoTableView) {
            cell.textLabel?.text = "info";
            cell.imageView?.image = UIImage(named: "Beach.jpg");
        }
        else {
            cell.textLabel?.text = "attendee";
        }

        return cell;
    }
    
    @IBAction func viewSwitched(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case Segment.kSegmentInfo:
                infoTableView.hidden = false;
                attendeesTableView.hidden = true;
                break;
            case Segment.kSegmentAttendees:
                infoTableView.hidden = true;
                attendeesTableView.hidden = false;
                break;
            default:
                break;
        }
    }
    
}
