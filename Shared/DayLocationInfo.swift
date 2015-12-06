//
//  DayVisitInfo.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 11/21/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import Foundation

class DayLocationInfo: NSObject, NSCoding {
    static private var formatter = NSDateFormatter()
    
    private class func beginningOfDay(date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.dateFromComponents(components)!
    }
    
    override class func initialize() {
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
    }
    
    let day: NSDate
    private(set) var locationItems: [BaseLocationItem]
    let formattedDayText: String
    
//    convenience init(visit: LKVisit) {
//        let locationItem = LocationItem(visit: visit)
//        self.init(locationItem: locationItem)
//    }
//    
//    convenience init(place: LKPlacemark, coordinate: CLLocationCoordinate2D) {
//        let locationItem = LocationItem(place: place, date: NSDate(), coordinate: coordinate)
//        self.init(locationItem: locationItem)
//    }
    
    init(locationItem: BaseLocationItem) {
        day = DayLocationInfo.beginningOfDay(locationItem.date)
        locationItems = [locationItem]
        formattedDayText = DayLocationInfo.formatter.stringFromDate(day)
    }
    
    func compare(other: DayLocationInfo) -> NSComparisonResult {
        return day.compare(other.day)
    }
    
    override func isEqual(other: AnyObject?) -> Bool {
        if let candidate = other as? DayLocationInfo {
            return self == candidate
        }
        return false
    }
    
    override var hashValue: Int {
        return day.hashValue
    }
    
    func addLocationItem(locationItem: BaseLocationItem) {
        var newItems = locationItems
        newItems.append(locationItem)
        newItems.sortInPlace() { $0.date.compare($1.date) == .OrderedDescending }
        locationItems = newItems
    }
    
    func removeLocationItem(locationItem: BaseLocationItem) {
        var exisitingIndex: Int?
        for (someIndex, someLocationItem) in locationItems.enumerate() {
            if someLocationItem.date == locationItem.date &&
                someLocationItem.coordinate.latitude == locationItem.coordinate.latitude &&
                someLocationItem.coordinate.longitude == locationItem.coordinate.longitude {
                    exisitingIndex = someIndex
                    break
            }
        }
        
        if let exisitingIndex = exisitingIndex {
            locationItems.removeAtIndex(exisitingIndex)
        }
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(day, forKey: "day")
        
//        if let stuff = locationItems as? [AnyObject] {
            aCoder.encodeObject(locationItems, forKey: "locationItems")
//        }
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        day = aDecoder.decodeObjectForKey("day") as! NSDate
        locationItems = aDecoder.decodeObjectForKey("locationItems") as! [BaseLocationItem]
        formattedDayText = DayLocationInfo.formatter.stringFromDate(day)
    }
    
}

func ==(lhs: DayLocationInfo, rhs: DayLocationInfo) -> Bool {
    return lhs.compare(rhs) == .OrderedSame
}
