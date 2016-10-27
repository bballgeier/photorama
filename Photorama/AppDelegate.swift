//
//  AppDelegate.swift
//  Photorama
//
//  Created by Benjamin Allgeier on 10/12/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let rootViewController = window!.rootViewController as! UINavigationController
//        let x: Int!
//        x = 3 // with or without this, x is ImplicitlyUnwrappedOptional<Int>
//        let x = 3 as Int!
//        print("type of x: \(type(of: x))")
//        print("type of rootViewController: \(type(of: rootViewController))")
        
        // if you put ! at end of NavigationController, I thought
        // you would get an implicitly unwrapped optional
        // but you get an error until you put ? after rootViewController below
        // which means you still have to unwrap
        // experiments above and in playground show that when using as or as!
        // you can only get an optional -- not an implicitly unwrapped optional
        
        // interesting enough, with as? you can get an optional of an optional
        // or an optional of an implicitly unwrapped optional
        
        let photosViewController = rootViewController.topViewController as! PhotosViewController
        photosViewController.store = PhotoStore()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

