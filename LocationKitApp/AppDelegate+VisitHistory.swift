//
//  AppDelegate+VisitHistory.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 11/21/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import Foundation
import LocationKit

extension AppDelegate {
    
    private static let maxVisitCount = 500
    
    func loadLocationHistory() {
        if let locationHistory = NSKeyedUnarchiver.unarchiveObjectWithFile(dataPath) as? [DayLocationInfo] {
            allLocationItems = locationHistory
        } else {
            loadDummyData()
        }
    }
    
    func addLocationItem(locationItem: LocationItem) {
        var newItems = allLocationItems
        
        let dayInfo = DayLocationInfo(locationItem: locationItem)
        if let existingIndex = newItems.indexOf(dayInfo) {
            let existingDayInfo = newItems[existingIndex]
            existingDayInfo.addLocationItem(locationItem)
            
        } else {
            newItems.append(dayInfo)
            newItems.sortInPlace() { $0.day.compare($1.day) == .OrderedDescending }
        }
        
        purgeAndSave(newItems)
    }

    func removeLocationItem(locationItem: LocationItem) -> Bool {
        var removedSection = false
        let dayInfo = DayLocationInfo(locationItem: locationItem)
        if let existingDayIndex = allLocationItems.indexOf(dayInfo) {
            var newItems = allLocationItems
            let existingDayVisitInfo = newItems[existingDayIndex]
            existingDayVisitInfo.removeLocationItem(locationItem)
            
            if existingDayVisitInfo.locationItems.isEmpty {
                newItems.removeAtIndex(existingDayIndex)
                removedSection = true
            }
            allLocationItems = newItems
            saveLocationHistory()
        }
        return removedSection
    }
    
    func updateLocationVisit(visit: LKVisit) {
        let locationItem = LocationItem(visit: visit)
        let dayInfo = DayLocationInfo(locationItem: locationItem)
        if let existingIndex = allLocationItems.indexOf(dayInfo) {
            let existingDayInfo = allLocationItems[existingIndex]
            var exisitingVisitIndex: Int?
            for (someIndex, someLocationItem) in existingDayInfo.locationItems.enumerate() {
                if someLocationItem.date == locationItem.date &&
                    someLocationItem.coordinate.latitude == locationItem.coordinate.latitude &&
                    someLocationItem.coordinate.longitude == locationItem.coordinate.longitude {
                        exisitingVisitIndex = someIndex
                        break
                }
            }
            
            if let exisitingVisitIndex = exisitingVisitIndex {
                existingDayInfo.locationItems[exisitingVisitIndex].visit = visit
                saveLocationHistory()
                NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.locationHistoryDidChangeNotificationName, object: nil)
            }
        }
    }
    
    func removeAllLocationItems() {
        purgeAndSave([])
    }
    
    
    private var dataPath: String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask,true)[0].stringByAppendingString("/visits.data")
    }
    
    func saveLocationHistory() {
        NSKeyedArchiver.archiveRootObject(allLocationItems, toFile: dataPath)
    }

    private func purgeAndSave(dayInfos: [DayLocationInfo]) {
        let purgedDayInfos: [DayLocationInfo]
        if dayInfos.count > AppDelegate.maxVisitCount {
            purgedDayInfos = Array(dayInfos[0..<AppDelegate.maxVisitCount])
        } else {
            purgedDayInfos = dayInfos
        }
        NSKeyedArchiver.archiveRootObject(purgedDayInfos, toFile: dataPath)
        
        allLocationItems = purgedDayInfos
        
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.locationHistoryDidChangeNotificationName, object: nil)
    }
    
}