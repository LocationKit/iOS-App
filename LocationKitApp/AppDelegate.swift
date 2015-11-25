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
    static let didEnterForeground = "applicationDidEnterForeground"
    static let didEnterBackground = "applicationDidEnterBackground"

    // Location History
    var allLocationItems: [DayLocationInfo] = []
    
    // Advanced Location Manager
    private(set) var locationManager: LKLocationManager!

    // MARK: Settings
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
            } else {
                locationManager.stopMonitoringVisits()
            }
        }
    }

    private let notificationsKey = "com.socialradar.LocationKitApp.notificationsEnabled"
    var notificationsEnabled: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(notificationsKey)
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: notificationsKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    // MARK: LKLocationManagerDelegate
    func locationManager(manager: LKLocationManager, didStartVisit visit: LKVisit) {
        let locationItem = LocationItem(visit: visit)

        // Add this item
        addLocationItem(locationItem)

        // If enabled, display a local notification
        if notificationsEnabled {
            let localNotification = UILocalNotification()
            localNotification.alertBody = "Visit started at \(locationItem.title)"
            localNotification.timeZone = NSTimeZone.localTimeZone()
            localNotification.fireDate = NSDate()
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }
    
    func locationManager(manager: LKLocationManager, didEndVisit visit: LKVisit) {
        updateLocationVisit(visit)
    }
    
    // MARK UIApplicationDelegate
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        NSUserDefaults.standardUserDefaults().registerDefaults([trackingKey: true])
        NSUserDefaults.standardUserDefaults().registerDefaults([notificationsKey: true])
        loadLocationHistory()
        
        locationManager = LKLocationManager()
        locationManager.apiToken = "5edaa3229d939d41"
        locationManager.advancedDelegate = self
        
        if trackingEnabled {
            locationManager.startMonitoringVisits()
        }
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.didEnterBackground, object: nil)
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.didEnterForeground, object: nil)
    }
}
