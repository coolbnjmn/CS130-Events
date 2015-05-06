//
//  PhoneNumberViewController.swift
//  Udder
//
//  Created by Matthew Clark on 4/30/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse

class PhoneNumberViewController: UIViewController {
    
    @IBOutlet weak var sendCodeBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBAction func sendCodePressed(sender: AnyObject) {
        let regex = NSRegularExpression(pattern: "[\\(\\)\\-\\s]", options: nil, error: nil)
        let phoneNumber = regex?.stringByReplacingMatchesInString(phoneTextField.text!, options: nil, range: NSMakeRange(0, count(phoneTextField.text!)), withTemplate: "")
        let parameters = ["phoneNumber": phoneNumber!]
        PFCloud.callFunctionInBackground("sendVerificationCode", withParameters: parameters) { results, error in
            if error != nil {
                // Your error handling here
                
            } else {
                NSLog("Success, text sent.")
            }
        }
    }
    
    
    @IBAction func formatPhoneNumber(sender: UITextField) {
        let regex = NSRegularExpression(pattern: "[\\(\\)\\-\\s]", options: nil, error: nil)
        let phoneNumber = regex?.stringByReplacingMatchesInString(sender.text, options: nil, range: NSMakeRange(0, count(sender.text!)), withTemplate: "")
        let phone:NSString = phoneNumber!

        if (count(phoneNumber!) > 3) {
            
            let areaCode = phone.substringWithRange(NSMakeRange(0, 3))
            var newPhone = "("+areaCode+") "
            
            if (count(phoneNumber!) > 3 && count(phoneNumber!) <= 6) {
                let someNums = phone.substringWithRange(NSMakeRange(3, count(phoneNumber!)-3))
                newPhone = newPhone + someNums
            } else {
                let firstThree = phone.substringWithRange(NSMakeRange(3, 3))
                newPhone = newPhone + firstThree + "-"
                newPhone = newPhone + phone.substringWithRange(NSMakeRange(6, count(phoneNumber!)-6))
            }
            sender.text = newPhone
        } else {
            let nums = phone.substringWithRange(NSMakeRange(0, count(phoneNumber!)))
            sender.text = nums
        }
        if (count(phoneNumber!) > 10) {
            sender.deleteBackward()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Step 1 of 2"
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.BlackTranslucent
        nav?.barTintColor = UIColor.themeColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        sendCodeBtn.backgroundColor = UIColor.themeColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelAndLogout")
        self.navigationItem.rightBarButtonItem!.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelAndLogout() {
        let alertController = UIAlertController(title: "Cancel and Logout?", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style:UIAlertActionStyle.Default) {
            UIAlertAction in
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appdelegate.FBlogout()
            })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
