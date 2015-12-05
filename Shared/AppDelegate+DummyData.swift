//
//  AppDelegate+DummyData.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 11/21/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import Foundation
import LocationKit
import AddressBookUI

extension AppDelegate {
    
    func loadDummyData() {
        let addressDictionary1: [NSString:String] = [
            kABPersonAddressStreetKey: "2001 L St NW",
            kABPersonAddressCityKey: "Washington",
            kABPersonAddressStateKey: "DC",
            kABPersonAddressZIPKey: "20036"]
        let coord1 = CLLocationCoordinate2D(latitude: 38.90393, longitude: -77.04514)
        let venue1 = LKVenue()
        venue1.name = "Starbucks"
        venue1.category = "Restaurants"
        venue1.subcategory = "Coffee and Tea"
        let placemark1 = DummyPlacemark(coordinate: coord1, addressDictionary: addressDictionary1, venue: venue1)
        
        let addressDictionary2: [NSString:String] = [
            kABPersonAddressStreetKey: "1111 19th St NW",
            kABPersonAddressCityKey: "Washington DC",
            kABPersonAddressZIPKey: "20036"]
        let coord2 = CLLocationCoordinate2D(latitude: 38.904510, longitude: -77.042936)
        let venue2 = LKVenue()
        venue2.name = "City Sports"
        venue2.category = "Retail"
        venue2.subcategory = "Sports"
        let placemark2 = DummyPlacemark(coordinate: coord2, addressDictionary: addressDictionary2, venue: venue2)
        
        let addressDictionary3: [NSString:String] = [
            kABPersonAddressStreetKey: "1440 P St NW",
            kABPersonAddressCityKey: "Washington DC",
            kABPersonAddressZIPKey: "20005"]
        let coord3 = CLLocationCoordinate2D(latitude: 38.909460, longitude: -77.033229)
        let venue3 = LKVenue()
        venue3.name = "Whole Foods"
        venue3.category = "Retail"
        venue3.subcategory = "Grocery"
        let placemark3 = DummyPlacemark(coordinate: coord3, addressDictionary: addressDictionary3, venue: venue3)
        
        let departureDate1 = NSDate(timeIntervalSinceReferenceDate: 469746944.39457)
        let arrivalDate1 = departureDate1.dateByAddingTimeInterval(60.0 * 10.0 * -1.0)
        let departureDate2 = arrivalDate1.dateByAddingTimeInterval((60.0 * 70.0 * -1.0) - (60.0 * 60.0 * 24.0))
        let arrivalDate2 = departureDate2.dateByAddingTimeInterval(60.0 * 20.0 * -1.0)
        let departureDate3 = arrivalDate2.dateByAddingTimeInterval((60.0 * 125.0 * -1.0))
        let arrivalDate3 = departureDate3.dateByAddingTimeInterval(60.0 * 44.0 * -1.0)
        
        let visit1 = DummyVisit(arrivalDate: arrivalDate1, departureDate: departureDate1, place: placemark1)
        let visit2 = DummyVisit(arrivalDate: arrivalDate2, departureDate: departureDate2, place: placemark2)
        let visit3 = DummyVisit(arrivalDate: arrivalDate3, departureDate: departureDate3, place: placemark3)
        
        addLocationItem(LocationItem(visit: visit1))
        addLocationItem(LocationItem(visit: visit2))
        addLocationItem(LocationItem(visit: visit3))
    }
}

class DummyPlacemark: LKPlacemark {
    private let _location: CLLocation
    private let _addressDictionary: [NSObject : AnyObject]?
    private let _venue: LKVenue?
    
    init(coordinate: CLLocationCoordinate2D, addressDictionary: [NSObject : AnyObject]?, venue: LKVenue?) {
        self._location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self._addressDictionary = addressDictionary
        self._venue = venue
        super.init()
    }
    
    override var location: CLLocation {
        return _location
    }
    
    override var addressDictionary: [NSObject : AnyObject]? {
        return _addressDictionary
    }
    
    override var venue: LKVenue? {
        return _venue
    }
    
    @objc override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_location, forKey: "location")
        aCoder.encodeObject(_addressDictionary, forKey: "addressDictionary")
        aCoder.encodeObject(_venue, forKey: "venue")
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        _location = aDecoder.decodeObjectForKey("location") as! CLLocation
        _addressDictionary = aDecoder.decodeObjectForKey("addressDictionary") as? [NSObject : AnyObject]
        _venue = aDecoder.decodeObjectForKey("venue") as? LKVenue
        super.init(coder: aDecoder)
    }
    
    override var thoroughfare: String? {
        return _addressDictionary?[kABPersonAddressStreetKey] as? String
    }
    
    override var locality: String? {
        return _addressDictionary?[kABPersonAddressCityKey] as? String
    }
    
    override var administrativeArea: String? {
        return _addressDictionary?[kABPersonAddressStateKey] as? String
    }
    
    override var postalCode: String? {
        return _addressDictionary?[kABPersonAddressZIPKey] as? String
    }
}

class DummyVisit: LKVisit {
    private let _arrivalDate: NSDate
    private let _departureDate: NSDate
    private let _place: LKPlacemark
    
    init(arrivalDate: NSDate, departureDate: NSDate, place: LKPlacemark) {
        _arrivalDate = arrivalDate
        _departureDate = departureDate
        _place = place
        super.init()
    }
    
    @objc override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_arrivalDate, forKey: "arrivalDate")
        aCoder.encodeObject(_departureDate, forKey: "departureDate")
        aCoder.encodeObject(_place, forKey: "place")
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        _arrivalDate = aDecoder.decodeObjectForKey("arrivalDate") as! NSDate
        _departureDate = aDecoder.decodeObjectForKey("departureDate") as! NSDate
        _place = aDecoder.decodeObjectForKey("place") as! LKPlacemark
        super.init(coder: aDecoder)
    }
    
    
    
    override var arrivalDate: NSDate {
        return _arrivalDate
    }
    
    override var departureDate: NSDate {
        return _departureDate
    }

    override var place: LKPlacemark {
        return _place;
    }
    
    override var coordinate: CLLocationCoordinate2D {
        return _place.location!.coordinate
    }

}