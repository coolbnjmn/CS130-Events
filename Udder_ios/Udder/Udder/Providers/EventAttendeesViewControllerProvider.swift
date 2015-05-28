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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        
        if(indexPath.row==0 && ((event?.isMyEvent ?? false) as Bool)) {
            event!.goToInvite?(event!)
        }
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var factor:Int = 0
        if(event?.isMyEvent ?? false as Bool) {
            factor = 1
        }
        
        if let attendees = event?.attendees {
            if (attendees.count == 0) {
                return 1+factor
            }
            else {
                return attendees.count+factor
            }
        }
        else {
            return 1+factor;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var factor:Int = 0
        if(event?.isMyEvent ?? false as Bool) {
            factor = 1
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kAttendeesTableViewCell) as! AttendeesTableViewCell;
        
        if(indexPath.row==0 && factor==1) {
            cell.makeInviteCell()
        }
        else if let attendees = event?.attendees {
            if (attendees.isEmpty) {
                cell.contactName.text = "No attendees for this event"
            }
            else {
                cell.configure(attendees[indexPath.row-factor])
            }
        }
        else {
            cell.contactName.text = "Loading attendees"
            //launch loading spin bar
        }
        
        return cell;
    }

}
