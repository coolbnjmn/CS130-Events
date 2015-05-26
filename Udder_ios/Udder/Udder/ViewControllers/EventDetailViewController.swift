//
//  EventViewController.swift
//  Udder
//
//  Created by Collin Yen on 4/17/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse

struct TableSegment {
    static let kSegmentInfo = 0;
    static let kSegmentAttendees = 1;
}

struct ResponseSegment {
    static let kSegmentAccept = 0;
    static let kSegmentDecline = 1;
}

class EventDetailViewController: BaseViewController {
    
    var event:EventModel?;
    var eventDetailProvider:EventDetailViewControllerProvider?;
    var eventAttendeesProvider:EventAttendeesViewControllerProvider?;
    var eventInvitation:InvitationModel?;
    
    var dateFormatter:NSDateFormatter = NSDateFormatter();
    
    // Views
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    // Constraints
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationViewWidthConstraint: NSLayoutConstraint!
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    // Segmented Controls
    @IBOutlet weak var responseSegmentedControl: SeparateTintSegmentedControl!
    @IBOutlet weak var tableSwitchSegmentedControl: UISegmentedControl!
    
    // Tables
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var attendeesTableView: UITableView!
    
    func setupWithEvent(eventModel:EventModel?) {
        self.event = eventModel;
        self.eventDetailProvider = EventDetailViewControllerProvider(eventModel: eventModel);
        self.eventAttendeesProvider = EventAttendeesViewControllerProvider(eventModel: eventModel);
    }
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = UIRectEdge.None;
        if(self.event!.eventHost.objectId == PFUser.currentUser().objectId)
        {
            self.setupMenuBarButtonItems()
        }
        self.populateData();
        self.setupTableViews();
        self.setupView();
    }
    
    func setupMenuBarButtonItems() {
        self.navigationItem.rightBarButtonItem = self.rightMenuBarButtonItem()
    }
    
    func rightMenuBarButtonItem() -> UIBarButtonItem {
        let rightButton:UIBarButtonItem = UIBarButtonItem(image: Constants.Images.PlusIcon, style:UIBarButtonItemStyle.Plain, target: self, action: "rightPlusButtonPressed:")
        rightButton.tintColor = UIColor.whiteColor()
        return rightButton
    }
    
    func rightPlusButtonPressed(sender: AnyObject) {
        var EditViewController:editViewController = editViewController(nibName: "WholeViewController", bundle: nil);
        EditViewController.setupWithEvent(self.event)
        self.navigationController?.pushViewController(EditViewController, animated: true);
    }
    
    override func viewDidLayoutSubviews() {
        self.headerViewHeightConstraint.constant = self.view.frame.size.height/3;
        
        var timeViewWidth:CGFloat = (self.view.frame.size.width - 2 * 2 * Constants.EventDetail.TableConstraints.kDefaultMargin) / 2;
        self.timeViewWidthConstraint.constant = timeViewWidth;
        self.locationViewWidthConstraint.constant = timeViewWidth;
        
        self.view.layoutSubviews();
    }
    
    @IBAction func acceptDeclineSwitched(sender: AnyObject) {
        var segmentedControl:SeparateTintSegmentedControl = sender as! SeparateTintSegmentedControl;
        segmentedControl.valueChanged();
        
        var response:Bool;
        var wasSelected:Bool = false;
        if let event = event {
            wasSelected = event.eventInvitation != nil;
        }
        
        switch sender.selectedSegmentIndex {
        case ResponseSegment.kSegmentAccept:
            response = true;
        case ResponseSegment.kSegmentDecline:
            response = false;
        default:
            return;
        }
        
        var successBlock:() -> Void = {
            self.setSegmentControllerForResponse(response);
        }
        
        var failureBlock: NSError -> Void = {
            (error: NSError) -> Void in
            println("Error: \(error)");
            if wasSelected {
                self.setSegmentControllerForResponse(!response);
            }
            else {
                segmentedControl.deselectControl();
            }
        }
        
        self.event?.updateInvitationResponse(response, success: successBlock, failure: failureBlock);
    }
    
    @IBAction func switchTable(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case TableSegment.kSegmentInfo:
            self.infoTableView.hidden = false;
            self.attendeesTableView.hidden = true;
        case TableSegment.kSegmentAttendees:                        
            self.infoTableView.hidden = true;
            self.attendeesTableView.hidden = false;
            event?.getAttendeesIfNeeded({self.attendeesTableView.reloadData()})
        default:
            return;
        }
    }
    
    // MARK: Helper Functions
    func setupTableViews() {
        let descriptionTableViewCellNib = UINib(nibName: "DescriptionTableViewCell", bundle: nil);
        self.infoTableView.registerNib(descriptionTableViewCellNib, forCellReuseIdentifier: Constants.CellIdentifiers.kDescriptionTableViewCell);
        
        let locationTableViewCellNib = UINib(nibName: "LocationTableViewCell", bundle: nil);
        self.infoTableView.registerNib(locationTableViewCellNib, forCellReuseIdentifier: Constants.CellIdentifiers.kLocationTableViewCell);
        
        let timeInfoTableViewCellNib = UINib(nibName: "TimeInfoTableViewCell", bundle: nil);
        self.infoTableView.registerNib(timeInfoTableViewCellNib, forCellReuseIdentifier: Constants.CellIdentifiers.kTimeInfoTableViewCell);
        
        self.infoTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.kStandardTableViewCell);
        
        self.infoTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        self.infoTableView.dataSource = self.eventDetailProvider;
        self.infoTableView.delegate = self.eventDetailProvider;

        
        let attendeesTableViewCellNib = UINib(nibName: "AttendeesTableViewCell", bundle: nil);
        self.attendeesTableView.registerNib(attendeesTableViewCellNib, forCellReuseIdentifier: Constants.CellIdentifiers.kAttendeesTableViewCell);
        
        self.attendeesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        self.attendeesTableView.dataSource = self.eventAttendeesProvider;
        self.attendeesTableView.delegate = self.eventAttendeesProvider;
    }
    
    func populateData() {
        if let validatedEvent = self.event {
            self.titleLabel.text = validatedEvent.eventTitle;
            self.timeLabel.text = timeLabelString(validatedEvent.eventStartTime);
            self.locationLabel.text = validatedEvent.locationObject.placeLocationName;
            
            var imageUrl:NSURL = NSURL(string: validatedEvent.eventImage)!;
            self.backgroundImageView.sd_setImageWithURL(imageUrl, placeholderImage: Constants.PlaceHolders.EventImage);
            
            // Set the invitation if there is one
            if let invitation = validatedEvent.eventInvitation {
                self.setSegmentControllerForResponse(invitation.invitationResponse);
            }
            
            self.navigationItem.title = "Event Detail";
        }
    }
    
    func setSegmentControllerForResponse(response:Bool?) {
        if let response = response {
            if response {
                self.responseSegmentedControl.selectedSegmentIndex = ResponseSegment.kSegmentAccept;
            }
            else {
                self.responseSegmentedControl.selectedSegmentIndex = ResponseSegment.kSegmentDecline;
            }
            
            self.responseSegmentedControl.valueChanged();
        }
    }
    
    func setupView() {
        var segmentedAttrs = [NSFontAttributeName: UIFont(name: Constants.StandardFormats.kStandardEventsTextFont, size: 12)!, NSForegroundColorAttributeName: UIColor.whiteColor()];
        self.responseSegmentedControl.configure(UIColor.themeColor(), selectColorRight: UIColor.standardRedColor(), unselectColor: UIColor.whiteColor(), textAttrs: segmentedAttrs);
        self.responseSegmentedControl.valueChanged();
        
        self.tableSwitchSegmentedControl.tintColor = UIColor.themeColor();
        
        self.backgroundGradientView.addGradient();
        
        // Set up category view
        if let validatedEvent = self.event {
            var categoryName:String = validatedEvent.eventCategory;
            var categoryImage:String? = Constants.EventCategoryImageMap[categoryName]
            
            if let validatedCategoryImage = categoryImage {
                self.categoryImageView?.image = UIImage(named: validatedCategoryImage);
            }
            else {
                self.categoryImageView?.image = UIImage(named: Constants.EventCategoryImageMap[Constants.EventCategories.kOtherCategory]!);
            }
        }
    }
    
    func timeLabelString(startTime:NSDate) -> String {
        var timeText:String = "";
        
        if startTime.isToday() {
            timeText = "Today";
        }
        else if startTime.isTomorrow() {
            timeText = "Tomorrow";
        }
        else if startTime.isThisWeek() && startTime.isLaterThanDate(NSDate.new()) {
            dateFormatter.dateFormat = Constants.DateFormats.kDayOfWeekFormat;
            timeText = dateFormatter.stringFromDate(startTime);
        }
        else if startTime.isNextWeek() && startTime.isLaterThanDate(NSDate.new()) {
            dateFormatter.dateFormat = Constants.DateFormats.kDayOfWeekFormat;
            timeText = "Next \(dateFormatter.stringFromDate(startTime))"
        }
        else {
            dateFormatter.dateFormat = Constants.DateFormats.kShortWeekDateFormat;
            timeText = dateFormatter.stringFromDate(startTime);
        }
        
        return timeText;
    }
}
