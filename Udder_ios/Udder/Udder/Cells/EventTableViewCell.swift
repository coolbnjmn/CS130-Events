//
//  EventTableViewCell.swift
//  Udder
//
//  Created by Benjamin Hendricks on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell, TTTAttributedLabelDelegate{

    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var timeLocationSubview: UIView!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    @IBOutlet weak var timeLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationLabelWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func eventTableViewCellInit(params: NSDictionary) {
        self.eventTitleLabel?.text = (params.objectForKey("title") as! String)
        self.timeLabel?.text = (params.objectForKey("time") as! String)
        self.locationLabel?.text = (params.objectForKey("location") as! String)
        self.backgroundImageView?.image = UIImage(named:"placeholder.png")
        self.locationImageView?.image = UIImage(named: "placeholder.png")
        self.timeImageView?.image = UIImage(named: "placeholder.png")
        self.categoryImageView?.image = UIImage(named: "placeholder.png")
                
        self.eventTitleLabel.textColor = UIColor.whiteColor()
        self.timeLocationSubview.backgroundColor = UIColor.clearColor()
        self.timeLabel.textColor = UIColor.whiteColor()
        self.locationLabel.textColor = UIColor.whiteColor()
       
        self.timeLabel.sizeToFit()
        self.timeLabelWidthConstraint.constant = self.timeLabel.frame.size.width
        
        let maxTimeLabelWidth : CGFloat = (self.timeLocationSubview.frame.size.width - self.locationImageView.frame.size.width) / 3
        let maxLocationLabelWidth : CGFloat = 2*maxTimeLabelWidth
        
        
        if(self.timeLabel.frame.size.width > maxTimeLabelWidth) {
            println("timeLabel too big")
            self.timeLabelWidthConstraint.constant = maxTimeLabelWidth
            self.timeLabel.frame.size.width = maxTimeLabelWidth
            println(self.timeLabel.frame)
        }
        
        self.locationLabel.sizeToFit()
        self.locationLabelWidthConstraint.constant = self.locationLabel.frame.size.width
        println("locationlabel size")
        println(self.locationLabel.frame)

        if(self.locationLabel.frame.size.width + self.locationLabel.frame.origin.x > self.timeLocationSubview.frame.width) {
            println("locationlabel too big")
            self.locationLabelWidthConstraint.constant = maxLocationLabelWidth
        }
        
        self.eventTitleLabel.font = UIFont(name: "Avenir-Book", size:24)
        self.timeLabel.font = UIFont(name: "Avenir-Book", size:18)
        self.locationLabel.font = UIFont(name: "Avenir-Book", size: 18)
        
    }
    
}
