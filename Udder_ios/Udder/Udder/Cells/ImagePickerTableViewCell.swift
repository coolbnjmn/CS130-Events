//
//  ImagePickerTableViewCell.swift
//  Udder
//
//  Created by Ari Ekmekji on 5/28/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class ImagePickerTableViewCell: UITableViewCell {

    @IBOutlet var myImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(url_string:String, category:String) {
        
        var img_name = "cover-" + category + ".png"
        
        if(url_string.isEmpty) {
            myImage.image = UIImage(named: img_name)
            if (myImage.image == nil) {
                myImage.image = UIImage(named: "cover-Other.png")
            }
        }
        else {
            var url = NSURL(string: url_string)
            myImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: img_name))
        }
    }

    
}
