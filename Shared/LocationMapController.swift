//
//  LocationController.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 11/21/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import LocationKit
import MessageUI

class LocationMapController: UIViewController, MKMapViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var actionButton: UIBarButtonItem!
    @IBOutlet var titleItem: UINavigationItem!
    
    private var locationPins: [MKPointAnnotation] = []
    private var locationHistoryObserver: AnyObject!
    private var backgroundObserver: AnyObject!
    private var foregroundObserver: AnyObject!

    private var appDelegate: AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(locationHistoryObserver)
    }
    
    private var appTitle: String {
        switch appDelegate.sdkType {
        case .LocationKit: return "Location Kit"
        case .AppleVisits: return "Apple Visits"
        case .Sense360: return "Sense 360"
        case .ParkourMethod: return "ParkourMethod"
        }
    }
    
    private var appColor: UIColor {
        switch appDelegate.sdkType {
        case .LocationKit: return UIColor(red: 253.0/255.0, green: 95.0/255.0, blue: 19.0/255.0, alpha: 1.0)
        case .AppleVisits: return UIColor(red: 156.0/255.0, green: 156.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        case .Sense360: return UIColor(red: 28.0/255.0, green: 142.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        case .ParkourMethod: return UIColor(red: 214.0/255.0, green: 11.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        titleItem.title = appTitle
        if let navigationController = navigationController {
            navigationController.navigationBar.barTintColor = appColor
        }
        
        if let recentDayVisitInfo = appDelegate.allLocationItems.first, locationItem = recentDayVisitInfo.locationItems.first {
            showMap(locationItem.coordinate, animated: false)
        }
        
        mapView.showsUserLocation = true

        backgroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidEnterBackgroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] _ in
            // We basically need to do this because Apple will keep a high powered Location Manager instance
            // around to show the blue user dot, but we don't want that when the app is in the background
            // as it'll result in additional, unwanted, battery drain
            self?.mapView.showsUserLocation = false
        }
        foregroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] _ in
            if let strongSelf = self {
                strongSelf.mapView.showsUserLocation = true
                // Center map on user's current location
                if let loc = strongSelf.mapView.userLocation.location {
                    strongSelf.mapView.setCenterCoordinate(loc.coordinate, animated: true)
                }
            }
        }
        locationHistoryObserver = NSNotificationCenter.defaultCenter().addObserverForName(AppDelegate.locationHistoryDidChangeNotificationName, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] _ in
            self?.loadPins()
        }
        
        loadPins()
    }
    
    func loadPins() {
        mapView.removeAnnotations(locationPins)
        
        var isFirst = true
        
        var pins: [MKPointAnnotation] = []
        var currentLocation = mapView.centerCoordinate
        for dayInfo in appDelegate.allLocationItems {
            for locationItem in dayInfo.locationItems {
                let pin = MKPointAnnotation()
                pin.coordinate = locationItem.coordinate
                pin.title = locationItem.title
                
                if isFirst {
                    isFirst = false

                    if let departureDate = locationItem.visit?.departureDate where departureDate == NSDate.distantFuture() {
                        // If departureDate is distant future, it is current
                        pin.subtitle = "Current"
                    } else if (locationItem.visit == nil) {
                        // If this isn't a visit but was manually triggered, it is current
                        pin.subtitle = "Current"
                    } else if locationItem.visit?.departureDate == nil {
                        // This shouldn't hit, but as a failsafe, in case there was an issue serializing/deserializing
                        // or something, if there is no departureDate on this first visit, it's current
                        pin.subtitle = "Current"
                    }
                    currentLocation = pin.coordinate
                }
                pins.append(pin)
            }
        }
        mapView.addAnnotations(pins)
        locationPins = pins
        showMap(currentLocation, animated: true)
    }
    
    // MARK: Actions
    @IBAction func addCurrentPlace() {
        appDelegate.locationManager.requestPlace() { [weak self] place, error in
            if let place = place {
                if let coordinate = place.location?.coordinate {
                    self?.addPlace(place, coordinate: coordinate)
                } else {
                    self?.appDelegate.locationManager.requestLocation() { [weak self] location, locationError in
                        if let location = location {
                            self?.addPlace(place, coordinate: location.coordinate)
                        } else {
                            self?.showErrorMessage("Could not find current place")
                        }
                    }
                }
                
            } else {
                self?.showErrorMessage("Could not find current place")
            }
        }
    }
    
    @IBAction func showActions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let emailAction = UIAlertAction(title: "Email Visit History", style: .Default) { [weak self] _ in
            self?.emailLocationHistory()
        }
        alertController.addAction(emailAction)
        
        let clearAction = UIAlertAction(title: "Clear Visit History", style: .Default) { [weak self] _ in
            self?.clearLocationHistory()
        }
        alertController.addAction(clearAction)
        
        let trackingAction: UIAlertAction
        if appDelegate.trackingEnabled {
            trackingAction = UIAlertAction(title: "Disable Location Tracking", style: .Default) { [weak self] _ in
                self?.appDelegate.trackingEnabled = false
            }
        } else {
            trackingAction = UIAlertAction(title: "Enable Location Tracking", style: .Default) { [weak self] _ in
                self?.appDelegate.trackingEnabled = true
            }
        }
        alertController.addAction(trackingAction)

        let notificationsAction: UIAlertAction
        if appDelegate.notificationsEnabled {
            notificationsAction = UIAlertAction(title: "Disable Visit Notifications", style: .Default) { [weak self] _ in
                self?.appDelegate.notificationsEnabled = false
            }
        } else {
            notificationsAction = UIAlertAction(title: "Enable Visit Notifications", style: .Default) { [weak self] _ in
                self?.appDelegate.notificationsEnabled = true
            }
        }
        alertController.addAction(notificationsAction)

        let howItWorksAction = UIAlertAction(title: "How does LocationKit work?", style: .Default) { _ in
            UIApplication.sharedApplication().openURL(NSURL(string: "https://locationkit.io/features/")!)
        }
        alertController.addAction(howItWorksAction)

//        let showHomeAction = UIAlertAction(title: "Show Home Location", style: .Default) { [weak self] _ in
//            self?.showHomeLocation()
//        }
//        alertController.addAction(showHomeAction)
//        
//        let showWorkAction = UIAlertAction(title: "Show Work Location", style: .Default) { [weak self] _ in
//            self?.showWorkLocation()
//        }
//        alertController.addAction(showWorkAction)
        
        let someAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(someAction)
        
        if let presenter = alertController.popoverPresentationController {
            presenter.barButtonItem = actionButton
            presenter.sourceView = self.view
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showMap(coordinate: CLLocationCoordinate2D, animated: Bool) {
        var region: MKCoordinateRegion
        // This is what MapKit sends us if we don't have a location yet
        let nullLocation = MKMapPointForCoordinate(CLLocationCoordinate2DMake(30.0, -40.0))
        let currentLocation = MKMapPointForCoordinate(coordinate)
        let isNullLocation = MKMetersBetweenMapPoints(nullLocation, currentLocation) < 100
        if isNullLocation {
            // Roughly center on the contiguous United States as the default when we don't have a location
            region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(39.833333, -98.583333), span: MKCoordinateSpan(latitudeDelta: 26.0, longitudeDelta: 26.0))
        } else {
            // If we have a location, center on that
            region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        }
        mapView.setRegion(region, animated: animated)
    }
    
    private var dataPath: String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask,true)[0].stringByAppendingString("/visits.data")
    }

    private func emailLocationHistory() {
        var csvText = LocationItem.csvText + "\n"
        for dayInfo in appDelegate.allLocationItems {
            for locationItem in dayInfo.locationItems {
                csvText += locationItem.csvText + "\n"
            }
        }
        let path = NSTemporaryDirectory() + "/location_data.csv"
        do {
            try csvText.writeToFile(path, atomically: false, encoding: NSASCIIStringEncoding)
            
            if let fileData = NSData(contentsOfFile: path) where MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setSubject("Location History")
                mail.addAttachmentData(fileData, mimeType: "text/csv", fileName: "location_data.csv")
                
                presentViewController(mail, animated: true, completion: nil)
                
            } else {
                showErrorMessage("Could not Email location history")
            }
        } catch {
            showErrorMessage("Could not Email location history")
        }
    }
    
    private func clearLocationHistory() {
        appDelegate.removeAllLocationItems()
    }
    
    private func showHomeLocation() {
        appDelegate.locationManager.requestHomeAddress() { [weak self] (placemark, error) in
            if let home = placemark, homeLocation = home.location {
                self?.showMap(homeLocation.coordinate, animated: true)
            } else {
                self?.showErrorMessage("Could not find Home location")
            }
        }
    }
    
    private func showWorkLocation() {
        appDelegate.locationManager.requestWorkAddress() { [weak self] (placemark, error) in
            if let work = placemark, workLocation = work.location {
                self?.showMap(workLocation.coordinate, animated: true)
            } else {
                self?.showErrorMessage("Could not find Work location")
            }
        }
    }
    
    private func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func addPlace(place: LKPlacemark, coordinate: CLLocationCoordinate2D) {
        let locationItem = LocationItem(place: place, date: NSDate(), coordinate: coordinate)
        appDelegate.addLocationItem(locationItem)
        showMap(coordinate, animated: true)
    }
    
    // MARK: Map delegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("visitPin")
        guard annotation !== mapView.userLocation else {
            return nil
        }

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "visitPin")
            pinView!.canShowCallout = true
        } else {
            pinView!.annotation = annotation
        }

        if let pin = pinView as? MKPinAnnotationView {
            if let subtitle = annotation.subtitle where subtitle == "Current" {
                pin.pinColor = .Red
            } else {
                pin.pinColor = .Green
            }
        }

        return pinView
    }

    // MARK: Mail delegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}
