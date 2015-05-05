//
//  ButtonCreationEventTableViewCell.swift
//  Udder
//
//  Created by shai segal on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class ButtonCreationEventTableViewCell: UITableViewCell {

    @IBOutlet weak var Button: UIButton!
    @IBAction func InfoSubmitted(sender: AnyObject) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
