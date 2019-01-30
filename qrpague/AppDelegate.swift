//
//  AppDelegate.swift
//  qrpague
//
//  Created by LEONARDO A SILVEIRA on 11/11/2018.
//  Copyright © 2018 QRPAGUE. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sufixUrl: String!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        return true
    }
    
//    func application(_ application: UIApplication,
//                     continue userActivity: NSUserActivity,
//                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool{
//        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
//            let incomingURL = userActivity.webpageURL,
//            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
//            let path = components.path,
//            let params = components.queryItems else {
//                return false
//        }
//
//        print("path = \(path)")
//
//        if let albumName = params.first(where: { $0.name == "albumname" } )?.value,
//            let photoIndex = params.first(where: { $0.name == "index" })?.value {
//
//            print("album = \(albumName)")
//            print("photoIndex = \(photoIndex)")
//            return true
//
//        } else {
//            print("Either album name or photo index missing")
//            return false
//        }
//    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        self.sufixUrl = url.absoluteString
        
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
        // Saves changes in the application's managed object context before the application terminates.
     }

   
 

}

