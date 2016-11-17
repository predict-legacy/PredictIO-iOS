//
//  PIONotificationViewController.swift
//  ExampleSwift
//
//  Created by zee-pk on 23/08/2016.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import PredictIO

class PIONotificationViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let dateFormatter = DateFormatter()
    
    let labels = ["Departing", "Departed", "Departure Cancelled", "STMP Callback", "Arrival Suspected", "Arrived", "Searching in perimeter", "Stationary after arrival", "TraveledByAirPlane"]
    
    let transportationModeLabels = ["TransportationMode: Undetermined", "TransportationMode: Car", "TransportationMode: NonCar"];
    
    let stationaryStates = ["Stationary: NO", "Stationary: YES"]

    let managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    let predictIOService: PredictIOService = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.predictIOService
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd/MM hh:mm a"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        let predictIOEnabled = defaults.bool(forKey: "PredictIOEnabled")
        navigationItem.rightBarButtonItem!.title = predictIOEnabled ? "Stop" : "Start"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startStopPredictIO(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        let predictIOEnabled = defaults.bool(forKey: "PredictIOEnabled")
        if predictIOEnabled {
            navigationItem.rightBarButtonItem!.title = "Start"
            predictIOService.stop()
        } else {
            navigationItem.rightBarButtonItem!.title = "Stop"
            predictIOService.startWithCompletionHandler({ (error) -> (Void) in
                if (error != nil) {
                    OperationQueue.main.addOperation({
                        let userInfo = error!._userInfo as! NSDictionary
                        let errorTitle = userInfo["NSLocalizedFailureReason"] as! String
                        let errorDescription = userInfo["NSLocalizedDescription"] as! String
                        let alertController = UIAlertController(title: errorTitle, message: errorDescription, preferredStyle: .alert)
                        let alertActionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertActionOK)
                        self.present(alertController, animated: true, completion: nil)
                        self.navigationItem.rightBarButtonItem!.title = "Start"
                        print("<predict.io> API Key: \(errorTitle) \(errorDescription)")
                        defaults.set(false, forKey: "PredictIOEnabled")
                        defaults.synchronize()
                    })
                } else {
                    print("Started predict.io...")
                }
            })
        }
    }
    
    @IBAction func showHomeWorkZones(_ sender: Any) {
        let homeZone = PredictIO.sharedInstance().homeZone
        let workZone = PredictIO.sharedInstance().workZone
        
        if ((homeZone != nil) || (workZone != nil)) {
            performSegue(withIdentifier: "showZones", sender: self)
        } else {
            let alertController = UIAlertController(title: "Home/Work Zones", message: "No zone information available at this moment. Please check again after some trips.", preferredStyle: .alert)
            let alertActionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertActionOK)
            present(alertController, animated: true, completion: nil)
        }
    }
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let infoDictionary = Bundle.main.infoDictionary
        let build = infoDictionary!["CFBundleVersion"];
        let version = PredictIO.sharedInstance().version
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        cell?.textLabel?.text = "SDK v\(version!)"
        cell?.detailTextLabel?.text = "Build v\(build!)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEvent: event)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showOnMap", sender: self)
    }

    func configureCell(_ cell: UITableViewCell, withEvent event: EventViaNotification) {
        let eventTypeIntegerValue = event.type!.intValue;
        let eventType = PredictIOEventType(rawValue: eventTypeIntegerValue)
        if (eventType == .transportMode) {
            let modeIntegerValue = event.mode!.intValue
            cell.textLabel!.text = transportationModeLabels[modeIntegerValue]
        } else if (eventType == .stationary) {
            let stationaryIntegerValue = event.stationary!.intValue
            cell.textLabel!.text = stationaryStates[stationaryIntegerValue]
        } else {
            cell.textLabel!.text = labels[eventTypeIntegerValue]
        }
        cell.detailTextLabel!.text =  dateFormatter.string(from: event.timeStamp! as Date)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "showOnMap") {
            let indexPath = tableView.indexPathForSelectedRow!
            let event = fetchedResultsController.object(at: indexPath)
            let coordinate = CLLocationCoordinate2DMake(event.latitude!.doubleValue, event.longitude!.doubleValue)
            let location = CLLocation(coordinate: coordinate, altitude: 0.0, horizontalAccuracy: event.accuracy!.doubleValue , verticalAccuracy: 0.0, course: 0.0, speed: 0.0, timestamp: event.timeStamp! as Date)
            let controller = segue.destination as! PIOMapViewController
            controller.location = location
            controller.zoneType = PIOZoneType(rawValue: event.zoneType as! Int32)!
        } else if (segue.identifier == "showZones") {
            let controller = segue.destination as! PIOZoneViewController
            controller.homeZone = PredictIO.sharedInstance().homeZone
            controller.workZone = PredictIO.sharedInstance().workZone
        }
    }

    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<EventViaNotification> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<EventViaNotification> = EventViaNotification.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<EventViaNotification>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! EventViaNotification)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
