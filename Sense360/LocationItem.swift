//
//  LocationItem.swift
//  Visits-Sense360
//
//  Created by Michael Sanford on 12/5/15.
//  Copyright © 2015-2016 Infinity Point. All rights reserved.
//

import Foundation
import CoreLocation
import SenseSdk

class LocationItem: BaseLocationItem {
    
    private let args: TriggerFiredArgs
    private var triggerExitDate: NSDate?

    init(args: TriggerFiredArgs) {
        self.args = args
        super.init()
    }
    
    private var firstPOI: PoiPlace {
        return args.places.first as! PoiPlace
    }
    
    override var title: String {
        return args.places.first?.description ?? ""
    }

    override var date: NSDate {
        return args.timestamp
    }
    
    override var coordinate: CLLocationCoordinate2D {
        return firstPOI.location.toCoordinate()
    }
    
    override var venueName: String? {
        return args.places.first?.description
    }
    
    override var thoroughfare: String? {
        return nil
    }
    
    override var subThoroughfare: String? {
        return nil
    }
    
    override var locality: String? {
        return nil
    }
    
    override var administrativeArea: String? {
        return nil
    }
    
    override var postalCode: String? {
        return nil
    }
    
    override var detectionMethod: String? {
        switch args.confidenceLevel {
        case .High: return "High"
        case .Medium: return "Medium"
        case .Low: return "Low"
        case .Undetermined: return "Undetermined"
        }
    }
    
    override var isVisit: Bool {
        return true
    }
    
    override var visitArrivalDate: NSDate {
        return args.timestamp
    }
    
    override var visitDepartureDate: NSDate {
        return triggerExitDate ?? NSDate.distantFuture()
    }

    @objc override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(args, forKey: "args")
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        args = aDecoder.decodeObjectForKey("args") as! TriggerFiredArgs
        super.init(coder: aDecoder)
    }
    
    func updateVisitDeparture(date: NSDate) {
        triggerExitDate = date
    }

}