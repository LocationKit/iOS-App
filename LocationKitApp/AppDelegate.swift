//
//  AppDelegate.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 11/20/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import UIKit
import LocationKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LKLocationManagerDelegate {

    static let locationHistoryDidChangeNotificationName = "locationHistoryDidChange"

    var allLocationItems: [DayLocationInfo] = []
    private(set) var locationManager: LKLocationManager!

    private let trackingKey = "com.socialradar.LocationKitApp.trackingEnabled"
    var trackingEnabled: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(trackingKey)
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: trackingKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if newValue {
                locationManager.startMonitoringVisits()
                locationManager.startUpdatingLocation()
            } else {
                locationManager.stopMonitoringVisits()
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        NSUserDefaults.standardUserDefaults().registerDefaults([trackingKey: true])
        loadLocationHistory()
        
        locationManager = LKLocationManager()
        locationManager.apiToken = "5edaa3229d939d41"
        locationManager.advancedDelegate = self
        
        if trackingEnabled {
            locationManager.startMonitoringVisits()
            locationManager.startUpdatingLocation()
        }
        
        return true
    }
    
    func locationManager(manager: LKLocationManager, didStartVisit visit: LKVisit) {
        addLocationItem(LocationItem(visit: visit))
    }
    
    func locationManager(manager: LKLocationManager, didEndVisit visit: LKVisit) {
        updateLocationVisit(visit)
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
