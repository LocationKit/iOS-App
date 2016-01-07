//
//  LocationController.swift
//  Visits-Shared
//
//  Created by Michael Sanford on 11/21/15.
//  Copyright © 2015-2016 Infinity Point. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

class LocationMapController: UIViewController, MKMapViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var titleItem: UINavigationItem!
    
    private var locationPins: [MKPointAnnotation] = []
    private var locationHistoryObserver: AnyObject!
    private var backgroundObserver: AnyObject!
    private var foregroundObserver: AnyObject!

    private var appDelegate: BaseAppDelegate {
        return UIApplication.sharedApplication().delegate as! BaseAppDelegate
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(locationHistoryObserver)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        if !appDelegate.currentPlaceSupported {
            navigationItem.leftBarButtonItem = nil
        }
        
        titleItem.title = appDelegate.appName
        navigationController?.navigationBar.barTintColor = appDelegate.appColor
        
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
        locationHistoryObserver = NSNotificationCenter.defaultCenter().addObserverForName(BaseAppDelegate.locationHistoryDidChangeNotificationName, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] _ in
            self?.loadPins()
        }
        
        loadPins()
        
        if case .Active = UIApplication.sharedApplication().applicationState {
            mapView.showsUserLocation = true
        }
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

                    if locationItem.isVisit && locationItem.visitDepartureDate == NSDate.distantFuture() {
                        // If departureDate is distant future, it is current
                        pin.subtitle = "Current"
                    } else if !locationItem.isVisit {
                        // If this isn't a visit but was manually triggered, it is current
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
        appDelegate.addCurrentPlace { [weak self] (coordindate, error) in
            if let coordindate = coordindate {
                self?.showMap(coordindate, animated: true)
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

        let howItWorksAction = UIAlertAction(title: "How does '\(appDelegate.appName)' work?", style: .Default) { [weak self] _ in
            if let strongSelf = self {
                UIApplication.sharedApplication().openURL(NSURL(string: strongSelf.appDelegate.helpUrlString)!)
            }
        }
        alertController.addAction(howItWorksAction)

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
        var csvText = BaseLocationItem.csvHeaderText + "\n"
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
    
    private func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
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
