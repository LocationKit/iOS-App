//
//  AppDelegate.swift
//  Visits-CoreLocation
//
//  Created by Michael Sanford on 12/5/15.
//  Copyright © 2015-2016 Infinity Point. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
final class AppDelegate : BaseAppDelegate, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager!
    private var mostRecentLocation: CLLocation?
    private var currentPlaceHandler: ((CLLocationCoordinate2D?, NSError?) -> Void)?
    private var timeoutTimer: NSTimer?
    
    override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        appName = "CoreLocation"
        appColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1.0)
        helpUrlString = "https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CoreLocation_Framework/"

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mostRecentLocation = locations.last
        
        timeoutTimer?.invalidate()
        if let currentPlaceHandler = currentPlaceHandler, location = mostRecentLocation {
            currentPlaceHandler(location.coordinate, nil)
        }
    }
    
    func locationManager(manager: CLLocationManager, didVisit visit: CLVisit) {
        let locationItem = LocationItem(visit: visit, placemark: nil)
        let dayInfo = DayLocationInfo(locationItem: locationItem)
        if let existingIndex = allLocationItems.indexOf(dayInfo) {
            let existingDayInfo = allLocationItems[existingIndex]
            var exisitingVisitIndex: Int?
            for (someIndex, someLocationItem) in existingDayInfo.locationItems.enumerate() {
                if someLocationItem.date == locationItem.date {
                        exisitingVisitIndex = someIndex
                        break
                }
            }
            
            if let exisitingVisitIndex = exisitingVisitIndex {
                let locationItem = existingDayInfo.locationItems[exisitingVisitIndex] as! LocationItem
                locationItem.visit = visit
                saveLocationHistory()
                NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.locationHistoryDidChangeNotificationName, object: nil)
            } else {
                reverseGeocode(visit)
            }
        }
        
    }
    
    private func reverseGeocode(visit: CLVisit) {
        let location = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [unowned self] (placemark, error) in
            let locationItem = LocationItem(visit: visit, placemark: placemark?.first)
            self.addLocationItem(locationItem)
            
            if self.notificationsEnabled {
                let localNotification = UILocalNotification()
                localNotification.alertBody = "Visit started at \(locationItem.title)"
                localNotification.timeZone = NSTimeZone.localTimeZone()
                localNotification.fireDate = NSDate()
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            }
        }
    }
    
    override func addCurrentPlace(handler: (CLLocationCoordinate2D?, NSError?) -> Void) {
        if let location = mostRecentLocation {
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [unowned self] (placemark, error) in
                if let placemark = placemark?.first {
                    let locationItem = LocationItem(place: placemark, date: NSDate(), coordinate: location.coordinate)
                    self.addLocationItem(locationItem)
                }
                handler(location.coordinate, nil)
            }
            
        } else {
            currentPlaceHandler = handler
            timeoutTimer?.invalidate()
            
            timeoutTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("onLocationTimeout"), userInfo: nil, repeats: false)
        }
    }
    
    override func startLocationTracking() {
        locationManager.startMonitoringVisits()
        locationManager.startUpdatingLocation()
    }
    
    override func stopLocationTracking() {
        locationManager.stopMonitoringVisits()
        locationManager.stopUpdatingLocation()
    }
    
    @objc private func onLocationTimeout(timer: NSTimer) {
        timer.invalidate()
        
        // TODO: show some error message to the user
    }
    
}
