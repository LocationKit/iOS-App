//
//  LocationEntriesController.swift
//  LocationKit
//
//  Created by Michael Sanford on 11/19/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import UIKit
import MapKit
import LocationKit

class LocationVisitsController: UITableViewController {

    private var visitHistoryObserver: AnyObject!
    
    private var appDelegate: AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    private var locationMapController: LocationMapController {
        return parentViewController as! LocationMapController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if appDelegate.allLocationItems.count == 0 {
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            emptyLabel.text = "We are currently computing your\n coordinates and will have your first\n location in just a few minutes..."
            emptyLabel.textAlignment = NSTextAlignment.Center
            emptyLabel.lineBreakMode = .ByWordWrapping
            emptyLabel.numberOfLines = 0
            self.tableView.backgroundView = emptyLabel
        }

        visitHistoryObserver = NSNotificationCenter.defaultCenter().addObserverForName(AppDelegate.locationHistoryDidChangeNotificationName, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] _ in
            self?.tableView.backgroundView = nil
            self?.tableView.reloadData()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(visitHistoryObserver)
    }
    
    func locationItemForIndexPath(indexPath: NSIndexPath) -> LocationItem {
        return appDelegate.allLocationItems[indexPath.section].locationItems[indexPath.row]
    }
    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return appDelegate.allLocationItems[section].formattedDayText
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return appDelegate.allLocationItems.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.allLocationItems[section].locationItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: LocationVisitCell
        if let reusableCell = tableView.dequeueReusableCellWithIdentifier(LocationVisitCell.reuseIdentifier) as? LocationVisitCell {
            cell = reusableCell
        } else {
            cell = LocationVisitCell(style: .Default, reuseIdentifier: LocationVisitCell.reuseIdentifier)
        }
        
        let locationItem = locationItemForIndexPath(indexPath)
        cell.updateUI(locationItem)
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let locationItem = locationItemForIndexPath(indexPath)
        locationMapController.showMap(locationItem.coordinate, animated: true)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let flag: UITableViewRowAction
        let locationItem = self.appDelegate.allLocationItems[indexPath.section].locationItems[indexPath.row]
        if locationItem.flagged {
            flag = UITableViewRowAction(style: .Normal, title: "Unflag as Incorrect") { [unowned self] _ in
                locationItem.flagged = false
                tableView.editing = false
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                self.appDelegate.saveLocationHistory()
            }
        } else {
            flag = UITableViewRowAction(style: .Normal, title: "Flag as Incorrect") { [unowned self] _ in
                locationItem.flagged = true
                tableView.editing = false
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                self.appDelegate.saveLocationHistory()
            }
        }
        flag.backgroundColor = UIColor.lightGrayColor()
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { [unowned self] _ in
            let locationItem = self.locationItemForIndexPath(indexPath)
            let sectionRemoved = self.appDelegate.removeLocationItem(locationItem)
            self.locationMapController.loadPins()
            if sectionRemoved {
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, flag]
    }

}
