//
//  File.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 12/5/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate : BaseAppDelegate {
    
    private var mostRecentLocation: CLLocation?
    
    override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        appName = "Parkour Method"
        appColor = UIColor(red: 233.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
        currentPlaceSupported = false
        helpUrlString = "https://www.parkourmethod.com/docs/"
        
        parkour.trackPOIWithHandler { [unowned self] (poiName, categoryOne, categoryTwo, fullAddress, city, state, zipCode, poiLocation, userLocation, distance) in
            let locationItem = LocationItem(poiName: poiName, categoryOne: categoryOne, categoryTwo: categoryTwo, fullAddress: fullAddress, city: city, state: state, zipCode: zipCode, poiLocation: poiLocation, userLocation: userLocation, distance: distance, date: NSDate())
            
            // Add this item
            self.addLocationItem(locationItem)
            
            self.mostRecentLocation = userLocation
            
            if self.notificationsEnabled {
                let localNotification = UILocalNotification()
                localNotification.alertBody = "Visit started at \(locationItem.title)"
                localNotification.timeZone = NSTimeZone.localTimeZone()
                localNotification.fireDate = NSDate()
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func addCurrentPlace(handler: (CLLocationCoordinate2D?, NSError?) -> Void) {
    }
    
    override func startLocationTracking() {
        parkour.start()
    }
    
    override func stopLocationTracking() {
        parkour.stop()
    }
    
}
