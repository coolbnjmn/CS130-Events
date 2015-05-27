//
//  RegEventCreationTableViewCell.swift
//  
//
//  Created by shai segal on 4/24/15.
//
//

import UIKit

@objc protocol RegCellDelegate{
    optional func setaddtext(cell:RegEventCreationTableViewCell)
}
class RegEventCreationTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: RegCellDelegate?
    
    @IBOutlet var titleTitleLabel: UILabel!
    @IBOutlet var titleTextField: UITextField!
    
    var answer = true
    
    func disable(){
        answer = false
        self.textFieldShouldBeginEditing(titleTextField)
    }
    
    func enable(){
        answer = true
        self.textFieldShouldBeginEditing(titleTextField)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return answer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleTextField.delegate = self
        titleTextField.borderStyle = UITextBorderStyle.None

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func finishedEditing(sender: AnyObject) {
        delegate?.setaddtext!(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.setaddtext!(self)
        return false
    }
}
