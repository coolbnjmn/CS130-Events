//
//  EventTableViewCell.swift
//  Udder
//
//  Created by Benjamin Hendricks on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var timeLocationSubview: UIView!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    
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
        self.eventTitleLabel.font = UIFont(name: "Avenir-Book", size:24)
        self.timeLabel.font = UIFont(name: "Avenir-Book", size:18)
        self.locationLabel.font = UIFont(name: "Avenir-Book", size: 18)
        
        self.timeLabel.sizeToFit()
        self.locationLabel.sizeToFit()
        
        let maxTimeLabelWidth : CGFloat = self.timeLocationSubview.frame.size.width / 3
        let maxLocationLabelWidth : CGFloat = 2*maxTimeLabelWidth
        
        if(self.timeLabel.frame.size.width > maxTimelabelWidth) {
            
        }
    }
    
}
