//
//  AttendeesTableViewCell.swift
//  Udder
//
//  Created by Ari Ekmekji on 5/14/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse

class AttendeesTableViewCell: UITableViewCell {

    @IBOutlet var contactImg: UIImageView!
    @IBOutlet var contactName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String, fid: String) {
        contactName.text = name
        contactName.font = UIFont(name: Constants.EventDetail.TableConstraints.kAttendeeTextFont, size: Constants.EventDetail.TableConstraints.kAttendeeTextSize)

        var img = getProfPic(fid)
        if(img != nil) {
//            img = cropToSquare(image: img!)
            contactImg.layer.cornerRadius = (contactImg.frame.width)/2.0;
            contactImg.image = img
            contactImg.layer.masksToBounds = true
            contactImg.clipsToBounds = true
            self.selectionStyle = .None
        }
    }
    
    func getProfPic(fid: String) -> UIImage? {
        if (fid != "") {
            var imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=square" //type=normal
            var imgURL = NSURL(string: imgURLString)
            var imageData = NSData(contentsOfURL: imgURL!)
            return UIImage(data: imageData!)
        }
        
        return nil
    }
    
    func cropToSquare(image originalImage: UIImage) -> UIImage {
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage)!
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)!
        
        return image
    }
    
}
