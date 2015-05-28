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
    @IBOutlet var fbLogo: UIImageView!
    @IBOutlet var contactLogo: UIImageView!
    @IBOutlet var invitePeopleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(contact: ContactModel) {
        invitePeopleLabel.text = ""
        contactName.text = contact.name
        contactName.font = UIFont(name: Constants.EventDetail.TableConstraints.kAttendeeTextFont, size: Constants.EventDetail.TableConstraints.kAttendeeTextSize)

        setProfPic(contact.fbid)
        
        if(contact.isInPhonebook!) {
            contactLogo.image = Constants.Images.ContactLogo
        }
        if(contact.isFBFriend!) {
            fbLogo.image = Constants.Images.FbLogo
        }
        
        fbLogo.layer.masksToBounds = true
        fbLogo.clipsToBounds = true
        contactLogo.layer.masksToBounds = true
        contactLogo.clipsToBounds = true
        
        self.selectionStyle = .None
    }
    
    func makeInviteCell() {
        contactName.text = ""
        invitePeopleLabel.text = "Invite More Friends"
        invitePeopleLabel.font = UIFont(name: Constants.EventDetail.TableConstraints.kAttendeeTextFont, size: Constants.EventDetail.TableConstraints.kAttendeeTextSize+3)
        invitePeopleLabel.textColor = UIColor.whiteColor()
        self.backgroundColor = Constants.Colors.ThemeColor
        self.selectionStyle = UITableViewCellSelectionStyle.Default
    }
    
    func setProfPic(fid: String) {
        if (fid != "") {
            var imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=normal" //type=normal
            var imgURL = NSURL(string: imgURLString)
            
            contactImg.sd_setImageWithURL(imgURL, placeholderImage: Constants.PlaceHolders.AttendeeImage)
        }
        else {
            contactImg.image = Constants.PlaceHolders.AttendeeImage
        }
        
        contactImg.layer.cornerRadius = contactImg.frame.width/2.0
        contactImg.layer.masksToBounds = true
        contactImg.clipsToBounds = true
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
