//
//  AppDelegate.swift
//  Visits-Shared
//
//  Created by Michael Sanford on 11/20/15.
//  Copyright © 2015-2016 Infinity Point. All rights reserved.
//

import UIKit
import CoreLocation

class BaseAppDelegate: UIResponder, UIApplicationDelegate {

    static let locationHistoryDidChangeNotificationName = "locationHistoryDidChange"
    private static let maxVisitCount = 500

    // Location History
    var allLocationItems: [DayLocationInfo] = []
    var appName: String!
    var appColor: UIColor!
    var detectionMethodSupported: Bool = false
    var currentPlaceSupported: Bool = true
    var helpUrlString: String! = nil

    // MARK: Location History
    func addCurrentPlace(handler: (CLLocationCoordinate2D?, NSError?) -> Void) {
        assert(false, "should never happen. this is an abstract function")
        handler(nil, NSError(domain: "", code: -1, userInfo: nil))
    }
    
    func loadLocationHistory() {
        if let locationHistory = NSKeyedUnarchiver.unarchiveObjectWithFile(dataPath) as? [DayLocationInfo] {
            allLocationItems = locationHistory
        }
    }
    
    func addLocationItem(locationItem: BaseLocationItem) {
        var newItems = allLocationItems
        
        let dayInfo = DayLocationInfo(locationItem: locationItem)
        if let existingIndex = newItems.indexOf(dayInfo) {
            let existingDayInfo = newItems[existingIndex]
            existingDayInfo.addLocationItem(locationItem)
            
        } else {
            newItems.append(dayInfo)
            newItems.sortInPlace() { $0.day.compare($1.day) == .OrderedDescending }
        }
        purgeAndSave(newItems)
    }

    func removeLocationItem(locationItem: BaseLocationItem) -> Bool {
        var removedSection = false
        let dayInfo = DayLocationInfo(locationItem: locationItem)
        if let existingDayIndex = allLocationItems.indexOf(dayInfo) {
            var newItems = allLocationItems
            let existingDayVisitInfo = newItems[existingDayIndex]
            existingDayVisitInfo.removeLocationItem(locationItem)
            
            if existingDayVisitInfo.locationItems.isEmpty {
                newItems.removeAtIndex(existingDayIndex)
                removedSection = true
            }
            allLocationItems = newItems
            saveLocationHistory()
        }
        return removedSection
    }
    
    
    func removeAllLocationItems() {
        purgeAndSave([])
    }
    
    func saveLocationHistory() {
        NSKeyedArchiver.archiveRootObject(allLocationItems, toFile: dataPath)
    }
    
    func purgeAndSave(dayInfos: [DayLocationInfo]) {
        let purgedDayInfos: [DayLocationInfo]
        if dayInfos.count > BaseAppDelegate.maxVisitCount {
            purgedDayInfos = Array(dayInfos[0..<BaseAppDelegate.maxVisitCount])
        } else {
            purgedDayInfos = dayInfos
        }
        NSKeyedArchiver.archiveRootObject(purgedDayInfos, toFile: dataPath)
        
        allLocationItems = purgedDayInfos
        
        NSNotificationCenter.defaultCenter().postNotificationName(BaseAppDelegate.locationHistoryDidChangeNotificationName, object: nil)
    }
    
    
    var dataPath: String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask,true)[0].stringByAppendingString("/visits.data")
    }

    // MARK: Settings
    private let trackingKey = "com.infinitypoint.locationapp.trackingEnabled"
    var trackingEnabled: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(trackingKey)
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: trackingKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if newValue {
                startLocationTracking()
            } else {
                stopLocationTracking()
            }
        }
    }

    private let notificationsKey = "com.infinitypoint.locationapp.notificationsEnabled"
    var notificationsEnabled: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(notificationsKey)
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: notificationsKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func startLocationTracking() {
        assert(false, "should never happen. this is an abstract function")
    }
    
    func stopLocationTracking() {
        assert(false, "should never happen. this is an abstract function")
    }

    // MARK UIApplicationDelegate
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        NSUserDefaults.standardUserDefaults().registerDefaults([trackingKey: true])
        NSUserDefaults.standardUserDefaults().registerDefaults([notificationsKey: true])
        loadLocationHistory()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        
        if trackingEnabled  {
            startLocationTracking()
        }
        
        return true
    }
}
