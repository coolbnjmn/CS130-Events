//
//  EventDetailViewControllerProvider.swift
//  Udder
//
//  Created by Collin Yen on 4/29/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

/* Class provides data for the event detail page */
var kDescriptionCellHeightOffset:CGFloat = 40;
var kDescriptionCellLabelMargin:CGFloat = 16;
var kDefaultDescriptionCellHeight:CGFloat = 110;

class EventDetailViewControllerProvider:BaseEventProvider {
    var shouldShowDescriptionReadMore:Bool = false;
    let dateFormatter:NSDateFormatter = NSDateFormatter();
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height:CGFloat = 44;
        switch (indexPath.row) {
        case Constants.EventDetail.Row.kDescriptionCell:
            if let validatedEvent = self.event {
                var attr = [NSFontAttributeName: UIFont(name: Constants.EventDetail.TableConstraints.kDescriptionTextFont, size: Constants.EventDetail.TableConstraints.kDescriptionTextSize)!];
                var textHeight:CGFloat = GeneralUtility.heightForString(validatedEvent.eventDescription, attrs: attr, width: tableView.frame.size.width - 2*kDescriptionCellLabelMargin);
                
                var totalHeight:CGFloat = textHeight + kDescriptionCellHeightOffset;
                
                if totalHeight < kDefaultDescriptionCellHeight || self.shouldShowDescriptionReadMore {
                    height = totalHeight;
                }
                else {
                    height = kDefaultDescriptionCellHeight;
                }
            }
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
                descriptionTableViewCell.configure(validatedEvent.eventDescription, shouldShowReadMore: shouldShowDescriptionReadMore);
                
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
        switch(indexPath.row) {
        case Constants.EventDetail.Row.kDescriptionCell:
            if !self.shouldShowDescriptionReadMore {
                tableView.beginUpdates();
                self.shouldShowDescriptionReadMore = true;
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Fade);
                tableView.endUpdates();
            }
        default:
            return;
        }
    }
}

