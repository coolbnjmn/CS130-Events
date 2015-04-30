//
//  EventViewController.swift
//  Udder
//
//  Created by Collin Yen on 4/17/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

struct Segment {
    static let kSegmentInfo = 0;
    static let kSegmentAttendees = 1;
}

class EventDetailViewController: UIViewController {
    
    var event:EventModel?;
    var eventDetailProvider:EventDetailViewControllerProvider?;
    
    // Views
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundGradientView: UIView!
    
    // Constraints
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationViewWidthConstraint: NSLayoutConstraint!
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    // Tables
    @IBOutlet weak var infoTableView: UITableView!
    
    var segmentSelected = Segment.kSegmentInfo;
    
    func setupWithEvent(eventModel:EventModel?) {
        self.event = eventModel;
        self.eventDetailProvider = EventDetailViewControllerProvider(eventModel: eventModel);
    }
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = UIRectEdge.None;
        self.populateData();
        self.setupTableViews();
    }
    
    func populateData() {
        if let validatedEvent = self.event {
            self.titleLabel.text = validatedEvent.eventTitle;
            // TODO: Proper time
            self.timeLabel.text = "12:00 pm";
            self.locationLabel.text = validatedEvent.eventLocation;
        }
    }
    
    // TODO: Implement gradient background
    /*func applyGradient(gradientView:UIView) {
        var gradient:CAGradientLayer = CAGradientLayer();
        var gradientFrame:CGRect = self.headerView.frame;
        gradientFrame.origin.x = 0;
        gradientFrame.origin.y = 0;
        gradient.frame = gradientFrame;
        
        var colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor];
        gradient.colors = colors;
        gradientView.layer.insertSublayer(gradient, atIndex: 0);
    }*/
    
    override func viewDidLayoutSubviews() {
        self.headerViewHeightConstraint.constant = self.view.frame.size.height/3;
        
        var timeViewWidth:CGFloat = (self.view.frame.size.width - 50) / 2;
        self.timeViewWidthConstraint.constant = timeViewWidth;
        self.locationViewWidthConstraint.constant = timeViewWidth;
        
        self.view.layoutSubviews();
    }
    
    func setupTableViews() {
        let descriptionTableViewCellNib = UINib(nibName: "DescriptionTableViewCell", bundle: nil);
        self.infoTableView.registerNib(descriptionTableViewCellNib, forCellReuseIdentifier: Constants.CellIdentifiers.kDescriptionTableViewCell);
        
        let locationTableViewCellNib = UINib(nibName: "LocationTableViewCell", bundle: nil);
        self.infoTableView.registerNib(locationTableViewCellNib, forCellReuseIdentifier: Constants.CellIdentifiers.kLocationTableViewCell);
        
        self.infoTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.kStandardTableViewCell);
        
        self.infoTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        self.infoTableView.dataSource = self.eventDetailProvider;
        self.infoTableView.delegate = self.eventDetailProvider;
    }
    
    @IBAction func viewSwitched(sender: UISegmentedControl) {
/*        switch sender.selectedSegmentIndex {
            case Segment.kSegmentInfo:
                infoTableView.hidden = false;
                attendeesTableView.hidden = true;
                break;
            case Segment.kSegmentAttendees:
                infoTableView.hidden = true;
                attendeesTableView.hidden = false;
                break;
            default:
                break;
        }*/
    }
    
}
