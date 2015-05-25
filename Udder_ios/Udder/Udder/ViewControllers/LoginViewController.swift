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

class LoginViewController: BaseViewController {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var backgroundImgView: UIImageView!
    
    @IBAction func pressedLogin(sender: AnyObject) {
        loginButton.enabled = false
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
                    self.loginButton.enabled = true
                }
                
            } else if (user.isNew) {
                NSLog("User with facebook signed up and logged in!");
                self.gatherInfo(false)
                let phoneValidated = PFUser.currentUser().objectForKey("phoneValidated") as! Bool
                if (phoneValidated) {
                    self.redirectToHome()
                } else {
                    self.redirectToPhoneNumber()
                }
            }
                
            else {
                NSLog("User with facebook logged in!");
                self.gatherInfo(true)
                let phoneValidated = PFUser.currentUser().objectForKey("phoneValidated") as! Bool
                if (phoneValidated) {
                    self.redirectToHome()
                } else {
                    NSLog("Not validated")
                    self.redirectToPhoneNumber()
                }
            }
            
        });

    }
    
    func gatherInfo(phoneValidated: Bool) {
        FBRequestConnection.startForMeWithCompletionHandler({ (connection :
            FBRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            PFUser.currentUser().setObject(result["id"],
                forKey: "facebookId")
            PFUser.currentUser().setObject(result["first_name"], forKey:"first_name")
            PFUser.currentUser().setObject(result["last_name"], forKey:"last_name")
            PFUser.currentUser().setObject(result["name"], forKey:"full_name")
            PFUser.currentUser().setObject(result["email"], forKey:"email")
            PFUser.currentUser().setObject(result["gender"], forKey:"gender")
            //Should only be done first time
            if (!phoneValidated) {
                PFUser.currentUser().setObject(false, forKey: "phoneValidated")
            }
            PFUser.currentUser().saveInBackgroundWithBlock({
                (success : Bool, error : NSError!) -> Void in
                if error != nil {
                    NSLog(error!.description);
                } else if success {
                    self.performSegueWithIdentifier("login",
                        sender: self);
//                    SVProgressHUD.dismiss()
                }
            })
        })
    }
    
    func redirectToHome() {
        let leftMenuViewController : SideMenuViewController = SideMenuViewController(nibName: "SideMenuViewController", bundle:nil)
        let navController : UINavigationController = UINavigationController(rootViewController: EventTableViewController(nibName: "EventTableViewController", bundle:nil))
        
        let container : MFSideMenuContainerViewController = MFSideMenuContainerViewController.containerWithCenterViewController(navController, leftMenuViewController: leftMenuViewController, rightMenuViewController: nil)
        self.presentViewController(container, animated: true, completion: nil)
        
        if UIApplication.sharedApplication().respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
    }
    
    func redirectToPhoneNumber() {
        let navController : UINavigationController = UINavigationController(rootViewController: PhoneNumberViewController(nibName: "PhoneNumberViewController", bundle:nil))
        self.presentViewController(navController, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginButton.enabled = true

//        loginButton.setTitle("Login with Facebook", forState: UIControlState.Normal)
//        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        loginButton.backgroundColor = UIColor.blueColor();
//        loginButton.layer.cornerRadius = 20;
//        loginButton.setImage(UIImage(named: "fb-btn.png"), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "pressedLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.backgroundColor = UIColor.whiteColor();
        
        self.view.addSubview(loginButton)
        let bgImg:UIImage = UIImage(named: "splash-bg.png")!
        self.backgroundImgView.contentMode = .ScaleAspectFit
        self.backgroundImgView.image = bgImg
        
//        UIColor(patternImage: )
//        self.view.backgroundColor = .drawInRect(self.view.bounds))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
