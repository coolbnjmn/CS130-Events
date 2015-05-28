//
//  TutorialViewController.swift
//  Udder
//
//  Created by Benjamin Hendricks on 5/27/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import Parse
import UIKit


class TutorialViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    let pageTitles = ["Be Spontaneous.", "Find events based on your interests...", "Connect with Friends...", "and make new ones."]
    var images = ["splash-bg.png","tutorial-1.png","tutorial-2.png","tutorial-3.png"]
    var count = 0
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var pageViewController : UIPageViewControllerWithOverlayIndicator!
    var pageControl : UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageViewController = UIPageViewControllerWithOverlayIndicator(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
       
        
        self.pageViewController.setViewControllers([self.viewControllerAtIndex(0)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController!.view)
        
        var pageViewRect = self.view.bounds
        pageViewController!.view.frame = pageViewRect
        pageViewController!.didMoveToParentViewController(self)
        self.view.backgroundColor = UIColor.whiteColor();

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    override func viewDidLayoutSubviews() {
        
        let mainView : UIView = self.view;
        let subviews: [UIView] = mainView.subviews as! [UIView];
        
        for subview : UIView in subviews {
            if subview is UIButton {
                println("button");
                self.view.bringSubviewToFront(subview);
            } else if subview is UILabel {
                println("label");
                self.view.bringSubviewToFront(subview);
            } else if subview is UIImageView {
                println("imageview");
                self.view.bringSubviewToFront(subview);
            }
        }
        
        super.viewDidLayoutSubviews();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> TutorialItemViewController
    {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return TutorialItemViewController()
        }
        
        var vc: TutorialItemViewController = TutorialItemViewController(nibName: "TutorialItemViewController", bundle: nil)
        vc.pageIndex = index
        vc.imageName = self.images[index];
        vc.text = self.pageTitles[index];
        
        return vc
    }
    
    // MARK -- Page View Controller Delegate
    
    // MARK: - Page View Controller Data Source
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int // The number of items reflected in the page indicator.
    {
        return self.pageTitles.count;
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int // The selected item reflected in the page indicator.
    {
        return 0;
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        
        var vc = viewController as! TutorialItemViewController
        var index = vc.pageIndex as Int
        
        
        if (index == 0 || index == NSNotFound)
        {
            return nil
            
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! TutorialItemViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound)
        {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count)
        {
            return nil
        }

        return self.viewControllerAtIndex(index)
        
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        println("pressed");
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
        self.loginButton.enabled = false
        let arr = ["user_about_me", "email", "user_friends"];
        PFFacebookUtils.logInWithPermissions(arr, block: {(user: PFUser!, error: NSError!) in
            if (user == nil) {
                if (error == nil) {
                    let alertController = UIAlertController(title: "Login Error", message:
                        "The user cancelled the Facebook login", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                }
                    
                else {
                    let alertController = UIAlertController(title: "Login Error", message:
                        "A login error occurred", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    self.loginButton.enabled = true
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
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
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

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
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

    }

}
