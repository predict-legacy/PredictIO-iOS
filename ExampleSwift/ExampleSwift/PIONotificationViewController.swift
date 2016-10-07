//
//  PIONotificationViewController.swift
//  ExampleSwift
//
//  Created by Zee on 8/23/16.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import PredictIO

class PIONotificationViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let dateFormatter = NSDateFormatter()
    
    let labels = ["Departing", "Departed", "Departure Cancelled", "STMP Callback", "Arrival Suspected", "Arrived", "Searching in perimeter"]
    
    let transportationModeLabels = ["TransportationMode: Undetermined", "TransportationMode: Car", "TransportationMode: NonCar"];
    
    let managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    let predictIOService: PredictIOService = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.predictIOService
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd/MM hh:mm a"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        let predictIOEnabled = defaults.boolForKey("PredictIOEnabled")
        navigationItem.rightBarButtonItem!.title = predictIOEnabled ? "Stop" : "Start"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startStopPredictIO(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let predictIOEnabled = defaults.boolForKey("PredictIOEnabled")
        if predictIOEnabled {
            navigationItem.rightBarButtonItem!.title = "Start"
            predictIOService.stop()
        } else {
            navigationItem.rightBarButtonItem!.title = "Stop"
            predictIOService.startWithCompletionHandler({ (error) -> (Void) in
                if (error != nil) {
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        let errorTitle = error!.userInfo["NSLocalizedFailureReason"] as! String
                        let errorDescription = error!.userInfo["NSLocalizedDescription"] as! String
                        let alertController = UIAlertController(title: errorTitle, message: errorDescription, preferredStyle: .Alert)
                        let alertActionOK = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(alertActionOK)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        self.navigationItem.rightBarButtonItem!.title = "Start"
                        print("<predict.io> API Key: \(errorTitle) \(errorDescription)")
                        defaults.setBool(false, forKey: "PredictIOEnabled")
                        defaults.synchronize()
                    })
                } else {
                    print("Started predict.io...")
                }
            })
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let build = infoDictionary!["CFBundleVersion"];
        let version = PredictIO.sharedInstance().version
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell")
        cell?.textLabel?.text = "SDK v\(version)"
        cell?.detailTextLabel?.text = "Build v\(build!)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let event = fetchedResultsController.objectAtIndexPath(indexPath) as! EventViaNotification
        configureCell(cell, withEvent: event)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showOnMap", sender: self)
    }

    func configureCell(cell: UITableViewCell, withEvent event: EventViaNotification) {
        let eventTypeIntegerValue = event.type!.integerValue;
        let eventType = PredictIOEventType(rawValue: eventTypeIntegerValue)
        if (eventType == .TransportMode) {
            let modeIntegerValue = event.mode!.integerValue
            cell.textLabel!.text = transportationModeLabels[modeIntegerValue]
            cell.accessoryType = .None
        } else {
            cell.textLabel!.text = labels[eventTypeIntegerValue]
            if (eventType == .DepartureCanceled) {
                cell.accessoryType = .None
            }
        }
        cell.detailTextLabel!.text =  dateFormatter.stringFromDate(event.timeStamp!)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showOnMap") {
            let indexPath = tableView.indexPathForSelectedRow!
            let event = (fetchedResultsController.objectAtIndexPath(indexPath) as! EventViaNotification)
            let location = CLLocation(coordinate: CLLocationCoordinate2DMake(event.latitude!.doubleValue, event.longitude!.doubleValue), altitude: 0.0, horizontalAccuracy: event.accuracy!.doubleValue , verticalAccuracy: 0.0, course: 0.0, speed: 0.0, timestamp: event.timeStamp!)
            let controller = segue.destinationViewController as! PIOMapViewController
            controller.location = location
        }
    }

    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("EventViaNotification", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master1")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, withEvent: anObject as! EventViaNotification)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}
