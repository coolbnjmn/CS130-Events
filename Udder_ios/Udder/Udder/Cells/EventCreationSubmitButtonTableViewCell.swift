//
//  EventCreationSubmitButtonTableViewCell.swift
//  Udder
//
//  Created by Ari Ekmekji on 5/27/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

class EventCreationSubmitButtonTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        submitButton.enabled = false
    }
    
    var delegate:WholeViewController?
    var action:(AnyObject -> Void)?

    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var pressedSubmit: UIButton!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addButtonAction(action:AnyObject -> Void) {
        self.action = action
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        println("Submit was pressed")
        self.action?(sender)
    }
    
}
