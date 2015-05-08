//
//  ValidationViewController.swift
//  Udder
//
//  Created by Matthew Clark on 5/6/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse

class ValidationViewController: UIViewController {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var verficationCode: UITextField!
    
    @IBAction func submitCodePressed(sender: AnyObject) {
        let parameters = ["phoneVerificationCode": verficationCode.text!]
        PFCloud.callFunctionInBackground("verifyPhoneNumber", withParameters: parameters) { results, error in
            if error != nil {
                // Your error handling here
                NSLog("Validation code is incorrect")
            } else {
                self.redirectToHome()
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
