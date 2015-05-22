//
//  WhereTableViewCell.swift
//  Udder
//
//  Created by shai segal on 4/25/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

/*@objc protocol WhereCellDelegate{
    optional func setwheretext(cell:WhereTableViewCell)
    optional func placesTableHidden()
}*/


//class WhereTableViewCell: UITableViewCell, UITextFieldDelegate{
class WhereTableViewCell: UITableViewCell {
    
//    var delegate: WhereCellDelegate?
    
    @IBOutlet weak var wheretext: UITextField!
   

    /*
    @IBAction func wheretextclicked(sender: UITextField) {
        delegate?.placesTableHidden!()
    }

    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool{
            delegate?.setwheretext!(self)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        delegate?.setwheretext!(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.setwheretext!(self)
        return false
    }*/
    
}
