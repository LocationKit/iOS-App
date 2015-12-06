//
//  LocationItem.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 12/5/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import Foundation
import CoreLocation

class LocationItem: BaseLocationItem {
    
    private let poiName: String?
    private let categoryOne: String?
    private let categoryTwo: String?
    private let fullAddress: String?
    private let city: String?
    private let state: String?
    private let zipCode: String?
    private let poiLocation: CLLocation?
    private let userLocation: CLLocation?
    private let distance: Double
    private let timestamp: NSDate
    
    init(poiName: String?, categoryOne: String?, categoryTwo: String?, fullAddress: String?, city: String?, state: String?, zipCode: String?, poiLocation: CLLocation?, userLocation: CLLocation?, distance: Double, date: NSDate) {
        self.poiName = poiName
        self.categoryOne = categoryOne
        self.categoryTwo = categoryTwo
        self.fullAddress = fullAddress
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.poiLocation = poiLocation
        self.userLocation = userLocation
        self.distance = distance
        timestamp = date
        super.init()
    }
    
    override var title: String {
        return poiName ?? ""
    }

    override var date: NSDate {
        return timestamp
    }
    
    override var coordinate: CLLocationCoordinate2D {
        return userLocation?.coordinate ?? poiLocation?.coordinate ?? kCLLocationCoordinate2DInvalid
    }
    
    override var venueName: String? {
        return poiName
    }
    
    override var thoroughfare: String? {
        return fullAddress
    }
    
    override var subThoroughfare: String? {
        return nil
    }
    
    override var locality: String? {
        return city
    }
    
    override var administrativeArea: String? {
        return state
    }
    
    override var postalCode: String? {
        return zipCode
    }
    
    override var isVisit: Bool {
        return poiLocation != nil
    }
    
    override var visitArrivalDate: NSDate {
        return timestamp
    }
    
    override var visitDepartureDate: NSDate {
        return NSDate.distantFuture()
    }

    @objc override func encodeWithCoder(aCoder: NSCoder) {
        if let poiName = poiName {
            aCoder.encodeObject(poiName, forKey: "poiName")
        }
        if let categoryOne = categoryOne {
            aCoder.encodeObject(categoryOne, forKey: "categoryOne")
        }
        if let categoryTwo = categoryTwo {
            aCoder.encodeObject(categoryTwo, forKey: "categoryTwo")
        }
        if let fullAddress = fullAddress {
            aCoder.encodeObject(fullAddress, forKey: "fullAddress")
        }
        if let city = city {
            aCoder.encodeObject(city, forKey: "city")
        }
        if let state = state {
            aCoder.encodeObject(state, forKey: "state")
        }
        if let zipCode = zipCode {
            aCoder.encodeObject(zipCode, forKey: "zipCode")
        }
        if let poiLocation = poiLocation {
            aCoder.encodeObject(poiLocation, forKey: "poiLocation")
        }
        if let userLocation = userLocation {
            aCoder.encodeObject(userLocation, forKey: "userLocation")
        }
        aCoder.encodeDouble(distance, forKey: "distance")
        aCoder.encodeObject(timestamp, forKey: "timestamp")
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        poiName = aDecoder.decodeObjectForKey("poiName") as? String
        categoryOne = aDecoder.decodeObjectForKey("categoryOne") as? String
        categoryTwo = aDecoder.decodeObjectForKey("categoryTwo") as? String
        fullAddress = aDecoder.decodeObjectForKey("fullAddress") as? String
        city = aDecoder.decodeObjectForKey("city") as? String
        state = aDecoder.decodeObjectForKey("state") as? String
        zipCode = aDecoder.decodeObjectForKey("zipCode") as? String
        poiLocation = aDecoder.decodeObjectForKey("poiLocation") as? CLLocation
        userLocation = aDecoder.decodeObjectForKey("userLocation") as? CLLocation
        distance = aDecoder.decodeDoubleForKey("distance")
        timestamp = aDecoder.decodeObjectForKey("timestamp") as! NSDate
        super.init(coder: aDecoder)
    }

}