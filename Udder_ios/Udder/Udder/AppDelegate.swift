//
//  AppDelegate.swift
//  Udder
//
//  Created by Benjamin Hendricks on 4/17/15.
//  Copyright (c) 2015 UCLA. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.whiteColor() // White color
        
        // change navigation item title color
        let buttonAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: Constants.StandardFormats.kButtonTextFont, size:Constants.StandardFormats.kButtonTextFontSize)!]
        navigationBarAppearace.titleTextAttributes = buttonAttributes
        
        
        Parse.setApplicationId("sIZN7Eo4sl6tR5ZdI04qIEKf5wm1QJN92jBxTLKb", clientKey: "IfKhgzcCazKuLPJCrQJwhDavQPTX59G0fo91bvuf")
        
        PFFacebookUtils.initializeFacebook();
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let leftMenuViewController : SideMenuViewController = SideMenuViewController(nibName: "SideMenuViewController", bundle:nil)
        
        if(PFUser.currentUser() == nil) { //Not logged in
            self.window!.rootViewController = LoginViewController(nibName: "LoginViewController", bundle:nil)
            application.unregisterForRemoteNotifications()
        }
        else { //Already logged in
            if application.respondsToSelector("registerUserNotificationSettings:") {
                let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
                let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
                application.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
            }
            
            let currentUser = PFUser.currentUser()
            //Update user with db attribute values
            //Error handling is needed
            let block:PFObjectResultBlock = {(PFObject object, NSError error) in
                let phoneValidated = currentUser.valueForKey("phoneValidated") as? Bool ?? false
                if let options = launchOptions as? [String : AnyObject], let notification: AnyObject = options[UIApplicationLaunchOptionsRemoteNotificationKey] {
                        self.application(application, didReceiveRemoteNotification:options)
                } else {
                    if (!phoneValidated) {
                        let navController : UINavigationController = UINavigationController(rootViewController: PhoneNumberViewController(nibName: "PhoneNumberViewController", bundle:nil))
                        self.window?.rootViewController = navController
                    } else {
                        let navController : UINavigationController = UINavigationController(rootViewController: EventTableViewController(nibName: "EventTableViewController", bundle:nil))
                        let container : MFSideMenuContainerViewController = MFSideMenuContainerViewController.containerWithCenterViewController(navController, leftMenuViewController: leftMenuViewController, rightMenuViewController: nil)
                        container.view.backgroundColor = UIColor.whiteColor()
                        self.window?.rootViewController = container
                    }
  
                }
                
            };
            currentUser.fetchIfNeededInBackgroundWithBlock(block);// TODO: Make this async
        }
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
            }
        }
        
        self.window!.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        if let user = PFUser.currentUser() {
            installation.setObject(PFUser.currentUser(), forKey:"user")
        }
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock(nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        PFPush.handlePush(userInfo)
        
        // TODO : Handle push notifications here -- and in didFinishlaunchingwithoptions, using a boolean.
        let notificationPayload : NSDictionary? = userInfo["aps"] as? NSDictionary;
        
        
        if let user = PFUser.currentUser() {
            if (userInfo["type"] as! String) == Constants.PushTypes.kNewInvitationType {
                
                if application.applicationState == UIApplicationState.Active {
                    let alertController = UIAlertController(title: "New Invitation", message:
                        "Go view it now!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    alertController.addAction(UIAlertAction(title: "Show", style: UIAlertActionStyle.Default, handler: { (action)  in
                        let navController : UINavigationController = UINavigationController(rootViewController: PendingInvitationsViewController(nibName: "EventTableViewController", bundle:nil))
                        let leftMenuViewController : SideMenuViewController = SideMenuViewController(nibName: "SideMenuViewController", bundle:nil)
                        let container : MFSideMenuContainerViewController = MFSideMenuContainerViewController.containerWithCenterViewController(navController, leftMenuViewController: leftMenuViewController, rightMenuViewController: nil)
                        container.view.backgroundColor = UIColor.whiteColor()
                        self.window?.rootViewController = container
                    }))
                    self.window?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
                    
                } else {
                    let navController : UINavigationController = UINavigationController(rootViewController: PendingInvitationsViewController(nibName: "EventTableViewController", bundle:nil))
                    let leftMenuViewController : SideMenuViewController = SideMenuViewController(nibName: "SideMenuViewController", bundle:nil)
                    let container : MFSideMenuContainerViewController = MFSideMenuContainerViewController.containerWithCenterViewController(navController, leftMenuViewController: leftMenuViewController, rightMenuViewController: nil)
                    container.view.backgroundColor = UIColor.whiteColor()
                    self.window?.rootViewController = container
                }
            }
        }
        
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block:nil)
            // TODO: Set a flag to know the push was received for next launch?
        }
    }
    
//Facebook functions
/***************/
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
                withSession:PFFacebookUtils.session())
    }
    
    func application(application: UIApplication,
        handleOpenURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
                withSession:PFFacebookUtils.session())
    }
/***************/

    func FBlogout() {
        PFUser.logOut()
        UIApplication.sharedApplication().unregisterForRemoteNotifications()
        UIView.transitionWithView(self.window!, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {self.window?.rootViewController = LoginViewController(nibName: "LoginViewController", bundle:nil)}, completion: nil)
        
    }
    
    
    

}

