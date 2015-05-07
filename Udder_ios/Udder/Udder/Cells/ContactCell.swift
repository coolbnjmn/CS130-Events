//
//  ContactCell.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/7/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Force it to use subtitle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
