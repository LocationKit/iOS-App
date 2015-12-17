//
//  File.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 12/5/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import UIKit
import SenseSdk
import CoreLocation

@UIApplicationMain
final class AppDelegate : BaseAppDelegate, TriggerFiredDelegate {
    
    override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        appName = "Sense360"
        appColor = UIColor(red: 27.0/255.0, green: 160.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        detectionMethodSupported = true
        currentPlaceSupported = false
        helpUrlString = "http://www.sense360.com/docs.html"

        SenseSdk.enableSdkWithKey("34bd012b-5782-4ed3-9598-1bd4fefb9e24")

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func addCurrentPlace(handler: (CLLocationCoordinate2D?, NSError?) -> Void) {
    }
    
    override func startLocationTracking() {
        let enterErrorPointer = SenseSdkErrorPointer.create()
        if let trigger = FireTrigger.whenEntersPoi("EnterPOI", type: .All, errorPtr: enterErrorPointer) {
            
            // register the unique trigger and specify that when the trigger fires it
            // should call our own "triggerFired" method
            SenseSdk.register(trigger: trigger, delegate: self)
            
        } else {
            //Logs an error message, put in your special error handling here.
            print(enterErrorPointer.error!.message)
        }
        
        let exitErrorPointer = SenseSdkErrorPointer.create()
        if let trigger = FireTrigger.whenEntersPoi("ExitPOI", type: .All, errorPtr: exitErrorPointer) {
            
            // register the unique trigger and specify that when the trigger fires it
            // should call our own "triggerFired" method
            SenseSdk.register(trigger: trigger, delegate: self)
            
        } else {
            //Logs an error message, put in your special error handling here.
            print(exitErrorPointer.error!.message)
        }
    }
    
    override func stopLocationTracking() {
        SenseSdk.unregister(name: "EnterPOI")
        SenseSdk.unregister(name: "ExitPOI")
    }
    
    // Called whenever the trigger has fired.
    // This is your chance to interact with the place that the user has arrived to or departed from.
    @objc func triggerFired(args: TriggerFiredArgs) {
        for place in args.places {
            // Cast to the correct type of place, this is different depending on the type of trigger
            let typedPlace = place as! PoiPlace
            // Logs the description of the place.  This is is where you write your custom code.
            print(typedPlace.description)
        }
        
        switch args.trigger.transitionType {
        case .Enter:
            
            let locationItem = LocationItem(args: args)
            addLocationItem(locationItem)
            
            if notificationsEnabled {
                let localNotification = UILocalNotification()
                localNotification.alertBody = "Visit started at \(locationItem.title)"
                localNotification.timeZone = NSTimeZone.localTimeZone()
                localNotification.fireDate = NSDate()
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            }
            
        case .Exit:
            let locationItem = LocationItem(args: args)
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
                    let locationItem = existingDayInfo.locationItems[exisitingVisitIndex] as! LocationItem
                    locationItem.updateVisitDeparture(NSDate())
                    saveLocationHistory()
                    NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.locationHistoryDidChangeNotificationName, object: nil)
                }
            }
            
        }
        
    }
    
}
