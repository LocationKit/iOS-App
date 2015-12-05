//
//  File.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 12/5/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import LocationKit

@UIApplicationMain
final class AppDelegate : BaseAppDelegate, LKLocationManagerDelegate {

    var locationManager: LKLocationManager!
    
    override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        locationManager = LKLocationManager()
        locationManager.apiToken = "5edaa3229d939d41"
        locationManager.advancedDelegate = self
        
        return result
    }
    
    override var trackingEnabled: Bool {
        get {
            return super.trackingEnabled
        }
        set {
            super.trackingEnabled = newValue
            
            if newValue {
                locationManager.startMonitoringVisits()
            } else {
                locationManager.stopMonitoringVisits()
            }
        }
    }
    
    // MARK: LKLocationManagerDelegate
    func locationManager(manager: LKLocationManager, didStartVisit visit: LKVisit) {
        let locationItem = LKLocationItem(visit: visit)
        
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
        let locationItem = LKLocationItem(visit: visit)
        let dayInfo = DayLocationInfo(locationItem: locationItem)
        if let existingIndex = allLocationItems.indexOf(dayInfo) {
            let existingDayInfo = allLocationItems[existingIndex]
            var exisitingVisitIndex: Int?
            for (someIndex, someLocationItem) in existingDayInfo.locationItems.enumerate() {
                if someLocationItem.date == locationItem.date &&
                    someLocationItem.coordinate.latitude == locationItem.coordinate.latitude &&
                    someLocationItem.coordinate.longitude == locationItem.coordinate.longitude {
                        exisitingVisitIndex = someIndex
                        break
                }
            }
            
            if let exisitingVisitIndex = exisitingVisitIndex {
                let locationItem = existingDayInfo.locationItems[exisitingVisitIndex] as! LKLocationItem
                locationItem.visit = visit
                saveLocationHistory()
                NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.locationHistoryDidChangeNotificationName, object: nil)
            }
        }
    }
    
    // MARK: App Theme
    override var appName: String {
        return "Location Kit"
    }
    
    // App Color
    override var appColor: UIColor {
        return UIColor(red: 253.0/255.0, green: 95.0/255.0, blue: 19.0/255.0, alpha: 1.0)
    }
    
    // CSV Header
    override var csvHeaderText: String {
        return LKLocationItem.csvText
    }
    
    override func addCurrentPlace(handler: (CLLocationCoordinate2D?, NSError?) -> Void) {
        locationManager.requestPlace() { [unowned self] place, error in
            if let place = place {
                if let coordinate = place.location?.coordinate {
                    let locationItem = LKLocationItem(place: place, date: NSDate(), coordinate: coordinate)
                    self.addLocationItem(locationItem)
                    handler(coordinate, nil)
                    
                } else {
                    self.locationManager.requestLocation() { [unowned self] location, locationError in
                        if let location = location {
                            let locationItem = LKLocationItem(place: place, date: NSDate(), coordinate: location.coordinate)
                            self.addLocationItem(locationItem)
                            handler(location.coordinate, nil)
                            
                        } else {
                            let coordinateError = NSError(domain: "LocationKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "could not obtain coordinate for current location"])
                            handler(nil, coordinateError)
                        }
                    }
                }
                
            } else {
                handler(nil, error)
            }
        }
    }
    
}
