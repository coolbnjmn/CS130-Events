//
//  EventTableViewCell.swift
//  Udder
//
//  Created by Benjamin Hendricks on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse

class EventTableViewCell: UITableViewCell {
    var hasGradient:Bool = false;
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var timeLocationSubview: UIView!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    
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
        self.timeLocationSubview.frame.size.width = self.frame.size.width
        
        self.eventTitleLabel?.text = (params.objectForKey("title") as! String)
        self.timeLabel?.text = (params.objectForKey("time") as! String)
        self.locationLabel?.text = (params.objectForKey("location") as! String)

        /*let block : PFIdResultBlock = { [weak self] (result: AnyObject!, error: NSError!) in
            let wSelf = self
            if(error == nil) {
                // no error
                let url : NSURL? = NSURL(string: result as! String)
                let data : NSData? = NSData(contentsOfURL: url!)
                wSelf?.backgroundImageView.image = UIImage(data: data!)
            } else {
            }
        }
        PFCloud.callFunctionInBackground("flickr", withParameters: ["title": params.objectForKey("title") as! String], block: block)*/
        
//        self.backgroundImageView?.image = UIImage(named:"placeholder.png")
        self.backgroundImageView?.sd_setImageWithURL(NSURL(string: params.objectForKey("image") as! String), placeholderImage:Constants.PlaceHolders.EventImage);
        self.locationImageView?.image = UIImage(named: "icon-location.png")
        self.timeImageView?.image = UIImage(named: "icon-time.png")
        
        // Set the Category image view
        var categoryName:String = params.objectForKey("category") as! String;
        var categoryImage:String? = Constants.EventCategoryImageMap[categoryName]
        
        if let validatedCategoryImage = categoryImage {
            self.categoryImageView?.image = UIImage(named: validatedCategoryImage);
        }
        else {
            self.categoryImageView?.image = UIImage(named: "placeholder.png");
        }
        
        self.eventTitleLabel.textColor = UIColor.whiteColor()
        self.timeLocationSubview.backgroundColor = UIColor.clearColor()
        self.timeLabel.textColor = UIColor.whiteColor()
        self.locationLabel.textColor = UIColor.whiteColor()
       
        self.timeLabel.sizeToFit()
        self.timeLabelWidthConstraint.constant = self.timeLabel.frame.size.width

        
        let maxTimeLabelWidth : CGFloat = (self.timeLocationSubview.frame.size.width) / 3
        let maxLocationLabelWidth : CGFloat = self.timeLocationSubview.frame.size.width - maxTimeLabelWidth - 2*self.locationImageView.frame.size.width
        
        
        if(self.timeLabel.frame.size.width > maxTimeLabelWidth) {
            self.timeLabelWidthConstraint.constant = maxTimeLabelWidth
            self.timeLabel.frame.size.width = maxTimeLabelWidth
            println(self.timeLabel.frame)
        }
        
        self.locationLabel.sizeToFit()
        self.locationLabelWidthConstraint.constant = self.locationLabel.frame.size.width
        

        if(self.locationLabel.frame.size.width + self.timeLabel.frame.size.width + 2*self.locationImageView.frame.size.width > self.timeLocationSubview.frame.width) {
            self.locationLabelWidthConstraint.constant = maxLocationLabelWidth
            self.locationLabel.frame.size.width = maxLocationLabelWidth
        }
        
        self.eventTitleLabel.font = UIFont(name: Constants.StandardFormats.kStandardEventsTextFont, size:20)
        self.timeLabel.font = UIFont(name: Constants.StandardFormats.kStandardEventsTextFont, size:14)
        self.locationLabel.font = UIFont(name: Constants.StandardFormats.kStandardEventsTextFont, size: 14)
    }
    
}
