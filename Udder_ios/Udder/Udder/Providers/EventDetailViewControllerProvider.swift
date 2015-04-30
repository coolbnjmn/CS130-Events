//
//  EventDetailViewControllerProvider.swift
//  Udder
//
//  Created by Collin Yen on 4/29/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

/* Class provides data for the event detail page */
class EventDetailViewControllerProvider:BaseEventProvider {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height:CGFloat;
        switch (indexPath.row) {
        case Constants.EventDetail.Row.kDescriptionCell:
            height = Constants.EventDetail.TableConstraints.kDescriptionViewHeight;
        default:
            height = 44;
        }
        
        return height;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell();

        if let validatedEvent = self.event {
            switch(indexPath.row) {
            case Constants.EventDetail.Row.kDescriptionCell:
                let descriptionTableViewCell:DescriptionTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kDescriptionTableViewCell) as! DescriptionTableViewCell;
                descriptionTableViewCell.descriptionLabel.text = validatedEvent.eventDescription;
                
                cell = descriptionTableViewCell;
            default:
                break;
            }
        }
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Should be implemented by subclass");
        return
    }
}

