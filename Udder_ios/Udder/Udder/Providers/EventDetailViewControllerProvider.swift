//
//  EventDetailViewControllerProvider.swift
//  Udder
//
//  Created by Collin Yen on 4/29/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

/* Class provides data for the event detail page */
import Parse

var kDescriptionCellHeightOffset:CGFloat = 45;
var kDescriptionCellLabelMargin:CGFloat = 16;
var kDefaultDescriptionCellHeight:CGFloat = 150;

class EventDetailViewControllerProvider:BaseEventProvider {
    var shouldShowDescriptionReadMore:Bool = true;
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
        case Constants.EventDetail.Row.kLocationCell:
            height = 185;
        case Constants.EventDetail.Row.kTimeCell:
            height = 75;
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
                cell = configureDescriptionCell(tableView, descriptionText: validatedEvent.eventDescription, shouldShowReadMore: self.shouldShowDescriptionReadMore);
                
            case Constants.EventDetail.Row.kTimeCell:
                cell = configureTimeCell(tableView, startTime: validatedEvent.eventStartTime, endTime: validatedEvent.eventEndTime);
                
            case Constants.EventDetail.Row.kLocationCell:
                cell = configureLocationCell(tableView, event: validatedEvent);
                
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
    
    // MARK: Helper Functions
    func configureDescriptionCell(tableView:UITableView, descriptionText:String, shouldShowReadMore:Bool) -> UITableViewCell {
        let descriptionTableViewCell:DescriptionTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kDescriptionTableViewCell) as! DescriptionTableViewCell;
        descriptionTableViewCell.configure(descriptionText, shouldShowReadMore: shouldShowReadMore);
        
        return descriptionTableViewCell
    }
    
    func configureLocationCell(tableView:UITableView, event:EventModel) -> UITableViewCell {
        let locationTableViewCell:LocationTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kLocationTableViewCell) as! LocationTableViewCell;
        
        locationTableViewCell.configure(event);
        
        return locationTableViewCell;
    }
    
    func configureTimeCell(tableView:UITableView, startTime:NSDate, endTime:NSDate) -> UITableViewCell {
        let timeTableViewCell:TimeInfoTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifiers.kTimeInfoTableViewCell) as! TimeInfoTableViewCell;
        
        var firstLineText:String = "";
        var secondLineText:String = "";
        
        // If the start date is equal to the end date
        if startTime.isEqualToDateIgnoringTime(endTime) {
            dateFormatter.dateFormat = Constants.DateFormats.kDateFormat;
            var dateText:String = dateFormatter.stringFromDate(startTime);
            
            dateFormatter.dateFormat = Constants.DateFormats.kTimeFormat;
            var startTimeText:String = dateFormatter.stringFromDate(startTime);
            var endTimeText:String = dateFormatter.stringFromDate(endTime);
            
            firstLineText = dateText;
            secondLineText = "from \(startTimeText) to \(endTimeText)";
        }
        else {
            dateFormatter.dateFormat = Constants.DateFormats.kFullDateFormat;
            firstLineText = dateFormatter.stringFromDate(startTime);
            secondLineText = dateFormatter.stringFromDate(endTime);
        }
        
        timeTableViewCell.startTimeLabel.text = firstLineText;
        timeTableViewCell.endTimeLabel.text = secondLineText;
        
        
        return timeTableViewCell;
    }
}

