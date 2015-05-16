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
        return 6;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kAttendeesTableViewCell) as! AttendeesTableViewCell;
        
        var name:String = ""
        var fid:String = ""
        switch(indexPath.row) {
        case 0: name="Ari Ekmekji"
                fid="10152853185652219"
            break
        case 1: name="Mark Ketenjian"
                fid="10152853185652219"
            break
        case 2: name="Matt Clark"
                fid="10205248970197720"
            break
        case 3: name="Benjamin Hendricks"
                fid="10155364447165018"
            break
        case 4: name="Collin Yen"
                fid="10153315583286098"
            break
        case 5: name="Shai Segal"
                fid = "10200709210568537"
            break
        default: name="John Appleseed"
        }
        

        cell.configure(name, fid: fid)
        
        return cell;
    }
}
