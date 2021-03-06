//
//  EventListViewControllerProvider.swift
//  Udder
//
//  Created by Collin Yen on 5/2/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

let kTableViewMargins:CGFloat = 4;

@objc protocol EventTableDelegate {
    func loadMoreData(page: Int, success: NSMutableArray -> Void, failure: NSError -> Void);
    
    // Reload Delegate
    func scrollViewDidScroll(scrollView: UIScrollView);
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool);
}

class EventTableViewControllerProvider: BaseProvider {
    var eventArray:NSMutableArray = NSMutableArray();
    var dateFormatter:NSDateFormatter = NSDateFormatter();
    var eventTableDelegate:EventTableDelegate?;
    var currentPage:Int = 0;
    var shouldLoadMore:Bool = true;
    
    // TODO: Search Provider should really be in a separate class
    var isSearching:Bool = false; // Set to true if you want to search and not load more
    
    func configure(events: NSMutableArray) {
        self.eventArray = events;
        self.shouldLoadMore = true;
        self.currentPage = 0;
    }
    
    func appendEvents(moreEvents:NSMutableArray) {
        self.eventArray.addObjectsFromArray(moreEvents as [AnyObject]);
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3; // space b/w cells
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventTableViewCell
        // Configure the cell...
        var event:EventModel = self.eventArray.objectAtIndex(indexPath.row) as! EventModel;
        
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setObject(event.eventTitle, forKey: "title")
        params.setObject(event.locationObject.placeLocationName, forKey: "location")
        
        dateFormatter.dateFormat = Constants.DateFormats.kShortWeekDateFormat;
        params.setObject(dateFormatter.stringFromDate(event.eventStartTime), forKey: "time")
        
        params.setObject(event.eventImage, forKey: "image");
        params.setObject(event.eventCategory, forKey: "category");
        params.setObject(event.eventPrivate, forKey: "private");
        cell.eventTableViewCellInit(params)
        
        if cell.hasGradient == false {
            var customBounds = tableView.bounds;
            customBounds.size.width = customBounds.size.width - kTableViewMargins*2;
            cell.gradientView.addGradient(customBounds);
            cell.hasGradient = true;
        }

        if (indexPath.row == (self.eventArray.count - 1)) && self.shouldLoadMore && !self.isSearching && (self.eventArray.count >= Constants.DatabasePagination.kNumberEventsToReturn){
            self.loadMore(tableView);
        }
        
        return cell
    }
    
    func loadMore(tableView: UITableView) {
        self.delegate?.displayLoadingHUD();
        self.currentPage += 1
        
        var successBlock:NSMutableArray -> Void = {
            (event: NSMutableArray) -> Void in
            self.delegate?.hideLoadingHUD();
            
            if event.count <= 0 {
                self.shouldLoadMore = false;
            }
            else {
                self.appendEvents(event);
                tableView.reloadData();
            }
        }
        
        var failureBlock:NSError -> Void = {
            (error: NSError) -> Void in
            self.delegate?.hideLoadingHUD();
            println("Error: \(error)");
        }
        
        self.eventTableDelegate?.loadMoreData(self.currentPage, success: successBlock, failure: failureBlock);
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        
        var event:EventModel = eventArray.objectAtIndex(indexPath.row) as! EventModel;
        var eventDetailViewController:EventDetailViewController = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil);
        eventDetailViewController.setupWithEvent(event);
        self.delegate?.pushViewController(eventDetailViewController, animated: true);
    }
    
    // MARK: Scrollview Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.eventTableDelegate?.scrollViewDidScroll(scrollView);
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.eventTableDelegate?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate);
    }
}
