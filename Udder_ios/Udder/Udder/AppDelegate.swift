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
        }
        else { //Already logged in
            let currentUser = PFUser.currentUser()
            //Update user with db attribute values
            //Error handling is needed
            currentUser.fetch() // TODO: Make this async
            let phoneValidated = currentUser.valueForKey("phoneValidated") as? Bool ?? false
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
        UIView.transitionWithView(self.window!, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {self.window?.rootViewController = LoginViewController(nibName: "LoginViewController", bundle:nil)}, completion: nil)
        
    }
    

}

