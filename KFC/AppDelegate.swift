//
//  AppDelegate.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/23/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import GoogleMaps
import FBSDKLoginKit
import FBSDKShareKit
import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //For gogole maps
        GMSServices.provideAPIKey("AIzaSyDL2_fjawveP2tkRDgtk3mT6sDErddQ-a8")
        //End
        
        //For Google Sign In
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        //End
        
        //For Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //End
        
        //For Twitter
        Fabric.with([Twitter.self])
        //End
        
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if (url.scheme == "com.googleusercontent.apps.775290173412-oq2b75tmh408iuc63fbaqk5immmj7sg6") {
            return GIDSignIn.sharedInstance().handleURL(url,
                sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String,
                annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
            
        } else if (url.scheme == "fb168725456842511"){
            return FBSDKApplicationDelegate.sharedInstance().application(
                app,
                openURL: url,
                sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String,
                annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
        }
        return false
    }

    //for iOS 8 and older
    func application(application: UIApplication,
        openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
            if (url.scheme == "com.googleusercontent.apps.775290173412-oq2b75tmh408iuc63fbaqk5immmj7sg6") {
                let options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
                UIApplicationOpenURLOptionsAnnotationKey: annotation]
                return GIDSignIn.sharedInstance().handleURL(url,
                    sourceApplication: sourceApplication,
                    annotation: options)
                
            } else if (url.scheme == "fb168725456842511"){
                return FBSDKApplicationDelegate.sharedInstance().application(
                    application,
                    openURL: url,
                    sourceApplication: sourceApplication,
                    annotation: annotation)
                
            }
            return false
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
        
        //For Facebook
        FBSDKAppEvents.activateApp()
        //End
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

