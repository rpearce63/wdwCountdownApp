//
//  AppDelegate.swift
//  WDWCountdownApp
//
//  Created by Rick Pearce.
//  Copyright © 2016 Rick Pearce. All rights reserved.

//

import UIKit
import GoogleMobileAds
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize the Google Mobile Ads SDK.
        // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
        GADMobileAds.configure(withApplicationID: "ca-app-pub-5535985233243357~8147034025")
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        sleep(2)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("Will Enter Foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Did Become Active")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//    func scheduleBadgeUpdate() {
//        let content = UNMutableNotificationContent()
//        let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
//        if (currentBadgeCount == 0) {return}
//        content.badge = currentBadgeCount - 1 as NSNumber
//        // Configure the trigger for midnight every day.
//        var dateInfo = DateComponents()
//        dateInfo.hour = 0
//        dateInfo.minute = 0
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
//        
//        // Create the request object.
//        let request = UNNotificationRequest(identifier: "UpdateBadge", content: content, trigger: trigger)
//        
//        // Schedule the request.
//        let center = UNUserNotificationCenter.current()
//        center.add(request) { (error : Error?) in
//            if let theError = error {
//                print(theError.localizedDescription)
//            }
//        }
//    }

}

