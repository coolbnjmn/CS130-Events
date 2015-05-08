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
        return 6;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kStandardTableViewCell) as! UITableViewCell;
        
        var name:String = ""
        switch(indexPath.row) {
        case 0: name="Ari Ekmekji"
            break
        case 1: name="Mark Ketenjian"
            break
        case 2: name="Matt Clark"
            break
        case 3: name="Benjamin Hendricks"
            break
        case 4: name="Collin Yen"
            break
        case 5: name="Shai Segall"
            break
        default: name="John Appleseed"
        }
        
        cell.textLabel?.text = name;
        
        return cell;
    }
}
