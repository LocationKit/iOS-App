//
//  LocationVisitCell.swift
//  Visits-Shared
//
//  Created by Michael Sanford on 11/20/15.
//  Copyright © 2015-2016 Infinity Point. All rights reserved.
//

import UIKit

class LocationVisitCell: UITableViewCell {
    static let reuseIdentifier = "LocationVisitCell"
    
    private static let timeFormatter = NSDateFormatter()
    private static let unknownCategoryImage: UIImage? = UIImage(named: "Unknown")

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var flaggedView: UIView!

    @IBOutlet weak var visitView: UIView!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var depatureLabel: UILabel!
    
    @IBOutlet weak var placeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var detectionMethodLabel: UILabel!

    override class func initialize() {
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
    }
    
    private var appDelegate: BaseAppDelegate {
        return UIApplication.sharedApplication().delegate as! BaseAppDelegate
    }

    func updateUI(locationItem: BaseLocationItem) {
        // populate address info
        var placeText: String = ""
        if let venueName = locationItem.venueName {
            var truncatedVenueName: String
            // Truncate venue name to 30 chars to prevent wrapping
            if venueName.characters.count > 27 {
                truncatedVenueName = venueName.substringWithRange(Range<String.Index>(start: venueName.startIndex, end: venueName.startIndex.advancedBy(27))) + "..."
            } else {
                truncatedVenueName = venueName
            }

            placeText += truncatedVenueName + "\n"
        }
        if let streetName = locationItem.thoroughfare {
            if let streetNumber = locationItem.subThoroughfare {
                placeText += "\(streetNumber) \(streetName)\n"
            } else {
                placeText += streetName + "\n"
            }
        }
        if let city = locationItem.locality, state = locationItem.administrativeArea, postalCode = locationItem.postalCode {
            placeText += "\(city), \(state)   \(postalCode)"
        } else if let city = locationItem.locality, postalCode = locationItem.postalCode {
            placeText += "\(city)   \(postalCode)"
        } else if let city = locationItem.locality, state = locationItem.administrativeArea {
            placeText += "\(city), \(state)"
        }
        placeLabel.text = placeText
        
        // populate categories
        var categoryText = ""
        if let categoryName = locationItem.venueCategory {
            categoryText = "Categories: \(categoryName)"
            
            if let subcategoryName = locationItem.venueSubcategory where !subcategoryName.isEmpty {
                categoryText += " - \(subcategoryName)"
                categoryImageView.image = UIImage(named: subcategoryName) ?? UIImage(named: categoryName) ?? LocationVisitCell.unknownCategoryImage
            } else {
                categoryImageView.image = UIImage(named: categoryName) ?? LocationVisitCell.unknownCategoryImage
            }
        } else {
            categoryImageView.image = LocationVisitCell.unknownCategoryImage
        }
        categoryLabel.text = categoryText
        
        // populate time information
        if locationItem.isVisit {
            visitView.hidden = false
            placeView.hidden = true
            
            // populate arrival and depature times
            arrivalLabel.text = LocationVisitCell.timeFormatter.stringFromDate(locationItem.visitArrivalDate)
            if locationItem.visitDepartureDate != NSDate.distantFuture() {
                depatureLabel.text = LocationVisitCell.timeFormatter.stringFromDate(locationItem.visitDepartureDate)
            } else {
                depatureLabel.text = ""
            }
        } else {
            visitView.hidden = true
            placeView.hidden = false
            
            // populate time
            timeLabel.text = LocationVisitCell.timeFormatter.stringFromDate(locationItem.date)
        }
        
        // populate flagged view
        flaggedView.hidden = !locationItem.flagged

        // populate detection method label
        if appDelegate.detectionMethodSupported {
            detectionMethodLabel.hidden = false
            if let source = locationItem.detectionMethod {
                detectionMethodLabel.text = "Detection Method: \(source)"
            } else {
                detectionMethodLabel.text = "Detection Method: Unknown"
            }
        } else {
            detectionMethodLabel.hidden = true
        }
    }
}


