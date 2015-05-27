//
//  EventAttendeesViewControllerProvider.swift
//  Udder
//
//  Created by Collin Yen on 5/1/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse

class EventAttendeesViewControllerProvider: BaseEventProvider {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.EventDetail.TableConstraints.kAttendeeCellHeight
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let attendees = event?.attendees {
            if (attendees.count == 0) {
                return 1
            }
            else {
                return attendees.count
            }
        }
        else {
            return 1;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kAttendeesTableViewCell) as! AttendeesTableViewCell;
        
        if let attendees = event?.attendees {
            if (attendees.isEmpty) {
                cell.contactName.text = "No attendees for this event"
            }
            else {
                cell.configure(attendees[indexPath.row])
            }
        }
        else {
            cell.contactName.text = "Loading attendees"
            //launch loading spin bar
        }
        
        return cell;
    }
}
