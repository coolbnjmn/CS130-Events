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
        Parse.setApplicationId("sIZN7Eo4sl6tR5ZdI04qIEKf5wm1QJN92jBxTLKb", clientKey: "IfKhgzcCazKuLPJCrQJwhDavQPTX59G0fo91bvuf")
        /*
self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

SideMenuViewController *leftMenuViewController = [[SideMenuViewController alloc] init];
SideMenuViewController *rightMenuViewController = [[SideMenuViewController alloc] init];
MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
containerWithCenterViewController:[self navigationController]
leftMenuViewController:leftMenuViewController
rightMenuViewController:rightMenuViewController];
self.window.rootViewController = container;
[self.window makeKeyAndVisible];


*/    
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let leftMenuViewController : SideMenuViewController = SideMenuViewController(nibName: "SideMenuViewController", bundle:nil)
        let navController : UINavigationController = UINavigationController(rootViewController: EventViewController(nibName: "EventViewController", bundle:nil))
        
        let container : MFSideMenuContainerViewController = MFSideMenuContainerViewController.containerWithCenterViewController(navController, leftMenuViewController: leftMenuViewController, rightMenuViewController: nil)
        
        self.window!.rootViewController = container
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
