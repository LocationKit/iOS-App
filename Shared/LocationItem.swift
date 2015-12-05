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
        return ""
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(flagged, forKey: "flagged")
    }

    @objc required init?(coder aDecoder: NSCoder) {
        flagged = aDecoder.decodeBoolForKey("flagged")
    }
}
