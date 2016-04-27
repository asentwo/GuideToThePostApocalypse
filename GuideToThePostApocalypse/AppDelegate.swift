//
//  AppDelegate.swift
//  WasteLandSurvivalQuizParse
//
//  Created by Justin Doo on 11/30/15.
//  Copyright © 2015 Justin Doo. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
   var window: UIWindow?
  let VERSION_NUM = "v1"
  let APP_ID = "8D2FD354-3D1D-CE63-FF2C-2188F2712800"
  let SECRET_KEY = "FECE275E-BC7E-9618-FFC0-21A4EDC16F00"
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios/guide#local-datastore
    //Parse.enableLocalDatastore()
    
    let backendless = Backendless.sharedInstance()
    backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    // This asks that the user should stay logged in by storing or caching the user's login
    // information so future logins can be skipped next time the user launches the app.
    backendless.userService.setStayLoggedIn(true)

    
    // Initialize Parse.
    Parse.setApplicationId("87A5spPzh2c4TyjG8cZBmpiLCCaruWVfXV567yR7",
      clientKey: "lio4F5ZLar678HBUfgstC8zuEfbfblJLpCcC4XQX")
    
    // [Optional] Track statistics around application opens.
    PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    
    if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) {
      
      let storyboard = UIStoryboard(name: "Survival", bundle: nil)
      let vc = storyboard.instantiateInitialViewController()
      //self.presentViewController(vc, animated: true, completion: nil)
      
      self.window!.rootViewController = vc
      self.window?.makeKeyAndVisible()
      
    } else {
      
      let storyboard = UIStoryboard(name: "Survival_Ipad", bundle: nil)
      let vc = storyboard.instantiateInitialViewController()
      //self.presentViewController(vc, animated: true, completion: nil)
      
      self.window!.rootViewController = vc
      self.window?.makeKeyAndVisible()
      
    }

    
//    let storyboard : UIStoryboard = UIStoryboard(name: "Survival", bundle: nil)
//    
//    if let lastRound = userDefaults.stringForKey(CURRENT_ROUND_KEY) {
//    
//    let initialViewController = storyboard.instantiateViewControllerWithIdentifier(lastRound)
//    
//    self.window?.rootViewController = initialViewController
//    
//    } else {
//      let initialViewController = storyboard.instantiateViewControllerWithIdentifier("Round_1")
//      
//      self.window?.rootViewController = initialViewController
//    }
    
    // ...
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

