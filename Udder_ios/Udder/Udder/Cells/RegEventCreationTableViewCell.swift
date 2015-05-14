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

    @IBOutlet weak var cellname: UILabel!
    
    @IBOutlet weak var addtext: UITextField!
    
    @IBAction func addtextclicked(sender: UITextField) {
    }
    
    var answer = true
    
    func disable(){
        answer = false
        self.textFieldShouldBeginEditing(addtext)
    }
    
    func enable(){
        answer = true
        self.textFieldShouldBeginEditing(addtext)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return answer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addtext.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        delegate?.setaddtext!(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.setaddtext!(self)
        return false
    }
}
