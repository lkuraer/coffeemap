//
//  AppDelegate.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 7/21/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseInstanceID
import FirebaseMessaging
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.statusBarStyle = .lightContent

        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "LitteraTextRegular", size: 12)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "LitteraTextRegular", size: 12)!], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: YELLOW_COLOR], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for: .normal)
        UITabBar.appearance().tintColor = YELLOW_COLOR
        UITabBar.appearance().barTintColor = YELLOW_COLOR

        UINavigationBar.appearance().tintColor = YELLOW_COLOR
        UINavigationBar.appearance().backgroundColor = UIColor.black
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "LitteraTextRegular", size: 15)!], for: UIControlState())
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "LitteraTextBold", size: 15)!]
        
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            if error == nil {
                let isAnonymous = user!.isAnonymous  // true
                print(isAnonymous)
                let uid = user!.uid
                let token = user!.refreshToken
                UserDefaults.standard.setValue(uid, forKey: UID_KEY)
                
                if let userID = UserDefaults.standard.value(forKey: UID_KEY) {
                    USER_ID = "\(userID)"
                    print("USER ID IS: \(USER_ID)")
                }
                
                print(uid)
                print(token!)
            } else {
                print(error!._code)
            }
        }
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        
        GMSServices.provideAPIKey("AIzaSyBs-g0Mu2oNoU-hbPtmhhCrYAd4Ddf4riY")

        return true
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            
            UserDefaults.standard.setValue(refreshedToken, forKey: "fcn")
            print("InstanceID token: \(refreshedToken)")
            
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
        
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}




