//
//  EventDetailViewControllerProvider.swift
//  Udder
//
//  Created by Collin Yen on 4/29/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

/* Class provides data for the event detail page */
class EventDetailViewControllerProvider:BaseEventProvider {
    let dateFormatter:NSDateFormatter = NSDateFormatter();
    
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
        return 3;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell();

        if let validatedEvent = self.event {
            switch(indexPath.row) {
            case Constants.EventDetail.Row.kDescriptionCell:
                let descriptionTableViewCell:DescriptionTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kDescriptionTableViewCell) as! DescriptionTableViewCell;
                descriptionTableViewCell.configure(validatedEvent.eventDescription);
                
                cell = descriptionTableViewCell;
            case Constants.EventDetail.Row.kTimeCell:
                let timeTableViewCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kStandardTableViewCell) as! UITableViewCell;
                
                dateFormatter.dateFormat = Constants.DateFormats.kFullDateFormat;
                var startTime:String = dateFormatter.stringFromDate(validatedEvent.eventStartTime);
                var endTime:String = dateFormatter.stringFromDate(validatedEvent.eventEndTime);
                var formattedTime:String = "From \(startTime) to \(endTime)";
                timeTableViewCell.textLabel?.text = formattedTime;
                
                cell = timeTableViewCell;
            case Constants.EventDetail.Row.kLocationCell:
                let locationTableViewCell:LocationTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kLocationTableViewCell) as! LocationTableViewCell;
                locationTableViewCell.configure(validatedEvent.eventLocation);
                
                cell = locationTableViewCell;
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

