//
//  LocationItem.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 11/21/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import LocationKit
import CoreLocation

class BaseLocationItem: NSObject, NSCoding {
    static let csvHeaderText = "visit|place,arrival_day,arrival_time,departure_day,departure_time,latitude,longitude,flagged,venue_name,street_address,city,state,postal_code"

    static let dayFormatter = NSDateFormatter()
    static let timeFormatter = NSDateFormatter()
    
    override class func initialize() {
        dayFormatter.dateStyle = .ShortStyle
        dayFormatter.timeStyle = .NoStyle
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
    }

    var flagged: Bool = false
    
    override init() {
        super.init()
    }
    
    var title: String {
        return ""
    }
    
    var date: NSDate {
        return NSDate()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return kCLLocationCoordinate2DInvalid
    }
    
    var venueName: String? {
        return nil
    }
    
    var venueCategory: String? {
        return nil
    }
    
    var venueSubcategory: String? {
        return nil
    }
    
    var thoroughfare: String? {
        return nil
    }
    
    var subThoroughfare: String? {
        return nil
    }
    
    var locality: String? {
        return nil
    }
    
    var administrativeArea: String? {
        return nil
    }
    
    var postalCode: String? {
        return nil
    }
    
    var detectionMethod: String? {
        return nil
    }
    
    var isVisit: Bool {
        return false
    }
    
    var visitArrivalDate: NSDate {
        return NSDate.distantPast()
    }
    
    var visitDepartureDate: NSDate {
        return NSDate.distantFuture()
    }
    
    var csvText: String {
        // visit|place,dd/mm/yyyy,16:34:50,dd/mm/yyyy,16:34:50,latitude,longitude,flagged,
        let title: String
        let departureText: String
        if isVisit {
            title = "visit"
            departureText = "\(BaseLocationItem.dayFormatter.stringFromDate(visitDepartureDate)),\(BaseLocationItem.timeFormatter.stringFromDate(visitDepartureDate))"
        } else {
            title = "place"
            departureText = ","
        }
        
        let streetName: String
        if let name = thoroughfare {
            if let streetNumber = subThoroughfare {
                streetName = "\(streetNumber) \(name)"
            } else {
                streetName = name
            }
        } else {
            streetName = ""
        }
        
        let city: String = locality ?? ""
        let state: String = administrativeArea ?? ""
        let zipCode: String = postalCode ?? ""
        
        let csvText = "\(title),\(BaseLocationItem.dayFormatter.stringFromDate(date)),\(BaseLocationItem.timeFormatter.stringFromDate(date)),\(departureText),\(coordinate.latitude),\(coordinate.longitude),\(flagged ? "1" : ""), \(venueName),\(streetName),\(city),\(state),\(zipCode)"
        return csvText
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(flagged, forKey: "flagged")
    }

    @objc required init?(coder aDecoder: NSCoder) {
        flagged = aDecoder.decodeBoolForKey("flagged")
    }
}
