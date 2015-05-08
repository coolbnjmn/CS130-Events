//
//  ValidationViewController.swift
//  Udder
//
//  Created by Matthew Clark on 5/6/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse

class ValidationViewController: BaseViewController {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var verficationCode: UITextField!
    
    @IBAction func submitCodePressed(sender: AnyObject) {
        
        submitBtn.enabled = false
        
        let parameters = ["phoneVerificationCode": verficationCode.text!]
        PFCloud.callFunctionInBackground("verifyPhoneNumber", withParameters: parameters) { results, error in
            if error != nil {
                // Your error handling here
                NSLog("Validation code is incorrect")
                let alertController = UIAlertController(title: "Incorrect Validation Code", message:
                    "", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                        self.verficationCode.text = ""
                        self.submitBtn.enabled = true
                    })
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                
                let alertController = UIAlertController(title: "Verification Successful", message:
                    "Welcome to Üdder!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Continue", style:UIAlertActionStyle.Default) {
                    UIAlertAction in
                        self.redirectToHome()
                    })
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func codeChanged(sender: UITextField) {
        if (count(sender.text) > 6) {
            sender.deleteBackward()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Step 2 of 2"
        
        submitBtn.backgroundColor = UIColor.themeColor()
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = backButton
//        navigationItem.leftBarButtonItem?.title = "Back"
//        navigationItem.backBarButtonItem?.title = "Back"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func redirectToHome() {
        let leftMenuViewController : SideMenuViewController = SideMenuViewController(nibName: "SideMenuViewController", bundle:nil)
        let navController : UINavigationController = UINavigationController(rootViewController: EventTableViewController(nibName: "EventTableViewController", bundle:nil))
        
        let container : MFSideMenuContainerViewController = MFSideMenuContainerViewController.containerWithCenterViewController(navController, leftMenuViewController: leftMenuViewController, rightMenuViewController: nil)
        self.presentViewController(container, animated: true, completion: nil)
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
