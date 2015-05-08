//
//  textviewTableViewCell.swift
//  Udder
//
//  Created by shai segal on 5/7/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit

@objc protocol tvCellDelegate{
    optional func up()
    optional func down(cell: textviewTableViewCell)
}

class textviewTableViewCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var mytext: UITextView!
    var my_int:Int = 1
    var delegate: tvCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mytext.text = "(optional)"
        mytext.textColor = UIColor.lightGrayColor()
        mytext.delegate = self
        
    }
    
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if (my_int == 1)
        {
            textView.text = ""
            my_int = 0
            textView.textColor = UIColor.blackColor()
        }
       // self.view.frame.origin.y -= 150
        delegate?.up!()
        return true
    }
    /*
    func navigationBar(navigationBar: UINavigationBar, shouldPushItem item: UINavigationItem) -> Bool {
    return true
    }*/
    
    func textViewDidEndEditing(textView: UITextView) {
       // self.view.frame.origin.y += 150
       // des_string = textView.text
        delegate?.down!(self)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        else {
            return true
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
