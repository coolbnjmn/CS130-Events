//
//  EventViewController.swift
//  Udder
//
//  Created by Collin Yen on 4/17/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

struct TableSegment {
    static let kSegmentInfo = 0;
    static let kSegmentAttendees = 1;
}

struct ResponseSegment {
    static let kSegmentAccept = 0;
    static let kSegmentDecline = 1;
}

class EventDetailViewController: UIViewController {
    
    var event:EventModel?;
    var eventDetailProvider:EventDetailViewControllerProvider?;
    var eventAttendeesProvider:EventAttendeesViewControllerProvider?;
    
    // Views
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
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
        self.populateData();
        self.setupTableViews();
        self.setupView();
    }
    
    func populateData() {
        if let validatedEvent = self.event {
            self.titleLabel.text = validatedEvent.eventTitle;
            // TODO: Proper time
            self.timeLabel.text = "12:00 pm";
            self.locationLabel.text = validatedEvent.eventLocation;
            
            var placeHolderImage:UIImage = UIImage(named: "Beach.jpg")!;
            var imageUrl:NSURL = NSURL(string: validatedEvent.eventImage)!;
            
            self.backgroundImageView.sd_setImageWithURL(imageUrl, placeholderImage: placeHolderImage);
        }
    }
    
    func setupView() {
        var segmentedAttrs = [NSFontAttributeName: UIFont(name: Constants.StandardFormats.kStandardTextFont, size: 12)!, NSForegroundColorAttributeName: UIColor.whiteColor()];
        self.responseSegmentedControl.configure(UIColor.standardGreenColor(), selectColorRight: UIColor.standardRedColor(), unselectColor: UIColor.whiteColor(), textAttrs: segmentedAttrs);
        self.responseSegmentedControl.valueChanged();
        
        self.tableSwitchSegmentedControl.tintColor = UIColor.standardGreenColor();
        
        self.backgroundGradientView.addGradient();
    }
    
    override func viewDidLayoutSubviews() {
        self.headerViewHeightConstraint.constant = self.view.frame.size.height/3;
        
        var timeViewWidth:CGFloat = (self.view.frame.size.width - 2 * 2 * Constants.EventDetail.TableConstraints.kDefaultMargin) / 2;
        self.timeViewWidthConstraint.constant = timeViewWidth;
        self.locationViewWidthConstraint.constant = timeViewWidth;
        
        self.view.layoutSubviews();
    }
    
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
        
        self.attendeesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.kStandardTableViewCell);
        self.attendeesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        self.attendeesTableView.dataSource = self.eventAttendeesProvider;
        self.attendeesTableView.delegate = self.eventAttendeesProvider;
    }
    
    @IBAction func acceptDeclineSwitched(sender: AnyObject) {
        var segmentedControl:SeparateTintSegmentedControl = sender as! SeparateTintSegmentedControl;
        segmentedControl.valueChanged();
        
        switch sender.selectedSegmentIndex {
        case ResponseSegment.kSegmentAccept:
            println("Accept selected");
        case ResponseSegment.kSegmentDecline:
            println("Reject selected");
        default:
            return;
        }
    }
    
    @IBAction func switchTable(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case TableSegment.kSegmentInfo:
            self.infoTableView.hidden = false;
            self.attendeesTableView.hidden = true;
        case TableSegment.kSegmentAttendees:
            self.infoTableView.hidden = true;
            self.attendeesTableView.hidden = false;
        default:
            return;
        }
    }
    
}
