//
//  LocationItem.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 12/5/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import Foundation
import LocationKit

class LocationItem: BaseLocationItem {
    
    var visit: LKVisit?
    
    private let placemark: LKPlacemark?
    private let placemarkDate: NSDate?
    private let placemarkCoordinate: CLLocationCoordinate2D?

    init(place: LKPlacemark, date: NSDate, coordinate: CLLocationCoordinate2D) {
        placemark = place
        placemarkDate = date
        placemarkCoordinate = coordinate
        visit = nil
        super.init()
    }
    
    init(visit: LKVisit) {
        self.visit = visit
        placemark = nil
        placemarkDate = nil
        placemarkCoordinate = nil
        super.init()
    }
    
    override var title: String {
        if let visit = visit {
            return visit.place.name ?? "\(visit.place.subThoroughfare) \(visit.place.thoroughfare)"
            
        } else if let placemark = placemark {
            return placemark.venue?.name ?? "\(placemark.subThoroughfare) \(placemark.thoroughfare)"
            
        } else {
            assert(false, "LocationItem in invalid state. this should never happen")
            return ""
        }
    }

    override var date: NSDate {
        return placemarkDate ?? visit!.arrivalDate
    }
    
    override var coordinate: CLLocationCoordinate2D {
        return placemarkCoordinate ?? visit!.coordinate
    }
    
    override var venueName: String? {
        return placemark?.venue?.name
    }
    
    override var venueCategory: String? {
        return placemark?.venue?.category
    }

    override var venueSubcategory: String? {
        return placemark?.venue?.subcategory
    }
    
    override var thoroughfare: String? {
        return placemark?.thoroughfare
    }
    
    override var subThoroughfare: String? {
        return placemark?.subThoroughfare
    }
    
    override var locality: String? {
        return placemark?.locality
    }
    
    override var administrativeArea: String? {
        return placemark?.administrativeArea
    }
    
    override var postalCode: String? {
        return placemark?.postalCode
    }
    
    override var detectionMethod: String? {
        return placemark?.locationKitEntranceSource
    }
    
    override var isVisit: Bool {
        return visit != nil
    }
    
    override var visitArrivalDate: NSDate {
        return visit?.arrivalDate ?? NSDate.distantPast()
    }
    
    override var visitDepartureDate: NSDate {
        return visit?.departureDate ?? NSDate.distantFuture()
    }

    @objc override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        
        if let visit = visit {
            aCoder.encodeObject(visit, forKey: "visit")
        }
        
        if let placemark = placemark {
            aCoder.encodeObject(placemark, forKey: "placemark")
        }
        
        if let placemarkDate = placemarkDate {
            aCoder.encodeObject(placemarkDate, forKey: "placemarkDate")
        }
        
        if let placemarkCoordinate = placemarkCoordinate {
            aCoder.encodeDouble(placemarkCoordinate.latitude, forKey: "placemarkLatitude")
            aCoder.encodeDouble(placemarkCoordinate.longitude, forKey: "placemarkLongitude")
        }
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        visit = aDecoder.decodeObjectForKey("visit") as? LKVisit
        placemark = aDecoder.decodeObjectForKey("placemark") as? LKPlacemark
        placemarkDate = aDecoder.decodeObjectForKey("placemarkDate") as? NSDate
        let latitude = aDecoder.decodeDoubleForKey("placemarkLatitude")
        let longitude = aDecoder.decodeDoubleForKey("placemarkLongitude")
        if (latitude != 0.0) && (longitude != 0.0) {
            placemarkCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            placemarkCoordinate = nil
        }
        super.init(coder: aDecoder)
    }

}