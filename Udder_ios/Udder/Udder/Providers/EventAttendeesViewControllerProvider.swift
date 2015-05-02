//
//  EventAttendeesViewControllerProvider.swift
//  Udder
//
//  Created by Collin Yen on 5/1/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class EventAttendeesViewControllerProvider: BaseEventProvider {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kStandardTableViewCell) as! UITableViewCell;
        
        cell.textLabel?.text = "Attendee \(indexPath.row)";
        
        return cell;
    }
}
