//
//  LoginViewController.swift
//  Udder
//
//  Created by Ari Ekmekji on 4/23/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LoginViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    
    @IBAction func pressedLogin(sender: AnyObject) {
        let arr = ["user_about_me", "email"];
        PFFacebookUtils.logInWithPermissions(arr, block: {(user: PFUser!, error: NSError!) in
            if (user == nil) {
                if (error == nil) {
                    let alertController = UIAlertController(title: "Login Error", message:
                        "The user cancelled the Facebook login", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                    
                else {
                    let alertController = UIAlertController(title: "Login Error", message:
                        "A login error occurred", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            } else if (user.isNew) {
                NSLog("User with facebook signed up and logged in!");
                PFUser.logOut();
                NSLog("Logged out");
            }
                
            else {
                NSLog("User with facebook logged in!");
                PFUser.logOut();
                NSLog("Logged out");
            }
            
        });

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginButton.setTitle("Login to Facebook", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.backgroundColor = UIColor.blueColor();
        loginButton.layer.cornerRadius = 15;
        loginButton.addTarget(self, action: "pressedLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.backgroundColor = UIColor.whiteColor();
        self.view.addSubview(loginButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
