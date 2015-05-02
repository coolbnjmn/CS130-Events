//
//  EventListViewControllerProvider.swift
//  Udder
//
//  Created by Collin Yen on 5/2/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class EventTableViewControllerProvider: BaseProvider {
    var eventArray:NSMutableArray = NSMutableArray();
    var dateFormatter:NSDateFormatter = NSDateFormatter();
    
    func configure(events: NSMutableArray) {
        self.eventArray = events;
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.eventArray.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventTableViewCell
        // Configure the cell...
        var event:EventModel = self.eventArray.objectAtIndex(indexPath.row) as! EventModel;
        
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setObject(event.eventTitle, forKey: "title")
        params.setObject(event.eventLocation, forKey: "location")
        
        dateFormatter.dateFormat = Constants.DateFormats.kShortWeekDateFormat;
        params.setObject(dateFormatter.stringFromDate(event.eventStartTime), forKey: "time")
        
        params.setObject(event.eventImage, forKey: "image");
        
        cell.eventTableViewCellInit(params)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        
        var event:EventModel = eventArray.objectAtIndex(indexPath.row) as! EventModel;
        var eventDetailViewController:EventDetailViewController = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil);
        eventDetailViewController.setupWithEvent(event);
        self.delegate?.pushViewController(eventDetailViewController, animated: true);
    }
}
