//
//  LocationVisitCell.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 11/20/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import UIKit
import LocationKit

class LocationVisitCell: UITableViewCell {
    static let reuseIdentifier = "LocationVisitCell"
    private static let timeFormatter = NSDateFormatter()
    private static let unknownCategoryImage: UIImage? = UIImage(named: "Unknown")

    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var flaggedView: UIView!

    @IBOutlet var visitView: UIView!
    @IBOutlet var arrivalLabel: UILabel!
    @IBOutlet var depatureLabel: UILabel!
    
    @IBOutlet var placeView: UIView!
    @IBOutlet var timeLabel: UILabel!
    
    override class func initialize() {
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
    }
    
    func updateUI(locationItem: LocationItem) {
        // populate address info
        let placemark = locationItem.place
        
        var placeText: String = ""
        if let venueName = placemark.venue?.name {
            placeText += venueName + "\n"
        }
        if let streetName = placemark.thoroughfare {
            if let streetNumber = placemark.subThoroughfare {
                placeText += "\(streetNumber) \(streetName)\n"
            } else {
                placeText += streetName + "\n"
            }
        }
        if let city = placemark.locality, state = placemark.administrativeArea, postalCode = placemark.postalCode {
            placeText += "\(city), \(state)   \(postalCode)"
        } else if let city = placemark.locality, postalCode = placemark.postalCode {
            placeText += "\(city)   \(postalCode)"
        } else if let city = placemark.locality, state = placemark.administrativeArea {
            placeText += "\(city), \(state)"
        }
        placeLabel.text = placeText
        
        // populate categories
        var categoryText = ""
        if let categoryName = placemark.venue?.category {
            categoryText = "Categories: \(categoryName)"
            
            if let subcategoryName = placemark.venue?.subcategory {
                categoryText += " : \(subcategoryName)"
                categoryImageView.image = UIImage(named: subcategoryName) ?? UIImage(named: categoryName) ?? LocationVisitCell.unknownCategoryImage
            } else {
                categoryImageView.image = UIImage(named: categoryName) ?? LocationVisitCell.unknownCategoryImage
            }
        } else {
            categoryImageView.image = LocationVisitCell.unknownCategoryImage
        }
        categoryLabel.text = categoryText
        
        // populate time information
        if let visit = locationItem.visit {
            visitView.hidden = false
            placeView.hidden = true
            
            // populate arrival and depature times
            arrivalLabel.text = LocationVisitCell.timeFormatter.stringFromDate(visit.arrivalDate)
            depatureLabel.text = LocationVisitCell.timeFormatter.stringFromDate(visit.departureDate)
            
        } else {
            visitView.hidden = true
            placeView.hidden = false
            
            // populate time
            timeLabel.text = LocationVisitCell.timeFormatter.stringFromDate(locationItem.date)
        }
        
        // populate flagged view
        flaggedView.hidden = !locationItem.flagged
    }    
}


