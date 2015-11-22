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
    
    private var locationPins: [MKPointAnnotation] = []
    private var locationHistoryObserver: AnyObject!

    private var appDelegate: AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(locationHistoryObserver)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        if let recentDayVisitInfo = appDelegate.allLocationItems.first, locationItem = recentDayVisitInfo.locationItems.first {
            showMap(locationItem.coordinate, aniamted: false)
        }
        
        mapView.showsUserLocation = true
        
        locationHistoryObserver = NSNotificationCenter.defaultCenter().addObserverForName(AppDelegate.locationHistoryDidChangeNotificationName, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] _ in
            self?.loadPins()
        }
        
        loadPins()
    }
    
    func loadPins() {
        mapView.removeAnnotations(locationPins)
        
        var isFirst = true
        
        var pins: [MKPointAnnotation] = []
        for dayInfo in appDelegate.allLocationItems {
            for locationItem in dayInfo.locationItems {
                let pin = MKPointAnnotation()
                pin.coordinate = locationItem.coordinate
                if let venueName = locationItem.visit?.place.venue?.name {
                    pin.title = venueName
                }
                
                if isFirst {
                    isFirst = false
                    if let departureDate = locationItem.visit?.departureDate where departureDate == NSDate.distantFuture() {
                        pin.subtitle = "Current"
                    }
                }
                pins.append(pin)
            }
        }
        mapView.addAnnotations(pins)
        locationPins = pins
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
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showMap(coordinate: CLLocationCoordinate2D, aniamted: Bool) {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        mapView.setRegion(region, animated: aniamted)
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
                self?.showMap(homeLocation.coordinate, aniamted: true)
            } else {
                self?.showErrorMessage("Could not find Home location")
            }
        }
    }
    
    private func showWorkLocation() {
        appDelegate.locationManager.requestWorkAddress() { [weak self] (placemark, error) in
            if let work = placemark, workLocation = work.location {
                self?.showMap(workLocation.coordinate, aniamted: true)
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
    }
    
    // MARK: Map delegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "visitPin")
        if let subtitle = annotation.subtitle where subtitle == "Current" {
            pinView.pinColor = .Red
        } else {
            pinView.pinColor = .Green
        }
        return pinView
    }

    // MARK: Mail delegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}