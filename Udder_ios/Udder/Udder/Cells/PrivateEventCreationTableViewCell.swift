//
//  PrivateEventCreationTableViewCell.swift
//  Udder
//
//  Created by shai segal on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

@objc protocol PrivateCellDelegate{
    optional func setswitch(cell:PrivateEventCreationTableViewCell)
}

class PrivateEventCreationTableViewCell: UITableViewCell {

    var delegate: PrivateCellDelegate?
    @IBOutlet weak var cellname: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    var Private = true
    @IBAction func switchflipped(sender: AnyObject) {
        if (Private == true){
            Private = false
        }
        else{
            Private = true
        }
        delegate?.setswitch!(self)
    }
    
    func switchSwitch (truth: Bool){
        self.`switch`!.setOn(truth, animated: true)
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
