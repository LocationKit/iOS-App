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
                locationManager.startUpdatingLocation()
            } else {
                locationManager.stopMonitoringVisits()
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    // MARK: LKLocationManagerDelegate
    func locationManager(manager: LKLocationManager, didStartVisit visit: LKVisit) {
        addLocationItem(LocationItem(visit: visit))
    }
    
    func locationManager(manager: LKLocationManager, didEndVisit visit: LKVisit) {
        updateLocationVisit(visit)
    }
    
    // MARK UIApplicationDelegate
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
    
}
