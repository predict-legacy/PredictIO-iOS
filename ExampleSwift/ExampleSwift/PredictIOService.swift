//
//  PredictIOService.swift
//  ExampleSwift
//
//  Created by Abdul Haseeb on 8/23/16.
//  Copyright © 2016 ParkTag. All rights reserved.
//

import Foundation
import CoreData

enum ParktagEvent : Int {
    case Departing = 0
    case Departed
    case DepartureCanceled
    case STMPCallBack
    case ArrivalSuspected
    case Arrived
    case Searching
}

class PredictIOService: NSObject, PredictIODelegate, NSFetchedResultsControllerDelegate {
    var managedObjectContext: NSManagedObjectContext!

    
    func departing(tripSegment: PIOTripSegment!) {
    print("Departing")
        self.insertParktagEvent(.Departing, location: tripSegment.departureLocation);
    }
    
    func departed(tripSegment: PIOTripSegment) {
        print("Departed")
        self.insertParktagEvent(.Departed, location: tripSegment.departureLocation);
    }

    func departureCanceled() {
        print("departureCanceled")
    }
    
    func transportationMode(tripSegment: PIOTripSegment) {
        print("transportationMode")
        self.insertParktagEvent(.STMPCallBack, location: tripSegment.departureLocation);
    }
    
    func arrivalSuspected(tripSegment: PIOTripSegment) {
        print("arrivalSuspected")
        self.insertParktagEvent(.ArrivalSuspected, location: tripSegment.departureLocation);
    }
    
    func arrived(tripSegment: PIOTripSegment) {
        print("arrived")
        self.insertParktagEvent(.Arrived, location: tripSegment.departureLocation);
    }
    
    func searchingInPerimeter(searchingLocation: CLLocation!) {
        print("searchingInPerimeter")
        self.insertParktagEvent(.Searching, location: searchingLocation);
    }
    
    func didUpdateLocation(location: CLLocation!) {
//        print("didUpdateLocation")
    }
    
    func insertParktagEvent(type: ParktagEvent, location: CLLocation) {
        
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        newManagedObject.setValue(location.coordinate.latitude, forKey: "latitude")
        newManagedObject.setValue(location.coordinate.longitude, forKey: "longitude")
        newManagedObject.setValue(type.rawValue, forKey: "type")
        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }

    }

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
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

    func startPredictIO()-> Void {
        PredictIO.sharedInstance().startWithCompletionHandler ({
            (error: NSError?) in
            if (error != nil) {
                print("\(error!.description)")
            } else {
                print("Started ParkTAG...")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                })
            }
        })
    }
    
    func stopPredictIO()-> Void {
        PredictIO.sharedInstance().stop()
    }
}