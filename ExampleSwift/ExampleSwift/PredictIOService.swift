//
//  PredictIOService.swift
//  ExampleSwift
//
//  Created by Zee on 8/23/16.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import PredictIO

enum PredictIOEventType: Int {
    case Departing = 0
    case Departed
    case DepartureCanceled
    case TransportMode
    case ArrivalSuspected
    case Arrived
    case Searching
}

class PredictIOService: NSObject, PredictIODelegate {

    let apiKey = "d34cac663cbea38f6c735a86c24d9b9f4d4e0a3457b7c4bca675fe85c78451db"

    override init() {
        super.init()

        let predictIO = PredictIO.sharedInstance()
        predictIO.delegate = self
        predictIO.apiKey = apiKey

        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(departingViaNotification),name: PIODepartingNotification ,object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(departedViaNotification),name: PIODepartedNotification ,object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(departureCanceledViaNotification),name: PIODepartureCanceledNotification ,object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(departureCanceledViaNotification),name: PIOTransportationModeNotification ,object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(arrivalSuspectedViaNotification),name: PIOArrivalSuspectedNotification ,object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(arrivedViaNotification),name: PIOArrivedNotification ,object: nil)
    }

    func resume() -> Void {
        // Check if PredictIO was set to run on every app launch
        let defaults = NSUserDefaults.standardUserDefaults()
        let predictIOEnabled = defaults.boolForKey("PredictIOEnabled")
        if predictIOEnabled {
            PredictIO.sharedInstance().startWithCompletionHandler({ (error) -> (Void) in
                if error != nil {
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        let errorTitle = error!.userInfo["NSLocalizedFailureReason"] as! String
                        let errorDescription = error!.userInfo["NSLocalizedDescription"] as! String
                        let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController;
                        let alertController = UIAlertController(title: errorTitle, message: errorDescription, preferredStyle: .Alert)
                        let alertActionOK = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(alertActionOK)
                        rootViewController!.presentViewController(alertController, animated: true, completion: nil)
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

    func startWithCompletionHandler(handler: (error: NSError?) -> (Void) ) -> Void {
        PredictIO.sharedInstance().startWithCompletionHandler(handler)
        // set to run PredictIO on every app launch
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "PredictIOEnabled")
        defaults.synchronize()
    }

    func stop() -> Void {
        PredictIO.sharedInstance().stop()
        // unset to run PredictIO on next app launch
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "PredictIOEnabled")
        defaults.synchronize()
    }

    // Mark - PredictIO Delegate methods

    func departing(tripSegment: PIOTripSegment!) {
        self.insertEventViaDelegate(.Departing, location: tripSegment.departureLocation, transportationMode: 0);
        print("Delegate - departing")
    }

    func departed(tripSegment: PIOTripSegment) {
        self.insertEventViaDelegate(.Departed, location: tripSegment.departureLocation, transportationMode: 0);
        print("Delegate - departed")
    }

    func departureCanceled() {
        self.insertEventViaDelegate(.DepartureCanceled, location: CLLocation(), transportationMode: 0);
        print("Delegate - departureCanceled")
    }

    func transportationMode(tripSegment: PIOTripSegment) {
        self.insertEventViaDelegate(.TransportMode, location: tripSegment.departureLocation, transportationMode: tripSegment.transportationMode.rawValue);
        print("Delegate - transportationMode \(tripSegment.transportationMode.rawValue)")
    }

    func arrivalSuspected(tripSegment: PIOTripSegment) {
        self.insertEventViaDelegate(.ArrivalSuspected, location: tripSegment.departureLocation, transportationMode: 0);
        print("Delegate - arrivalSuspected")
    }

    func arrived(tripSegment: PIOTripSegment) {
        self.insertEventViaDelegate(.Arrived, location: tripSegment.departureLocation, transportationMode: 0);
        print("Delegate - arrived")
    }

    func searchingInPerimeter(searchingLocation: CLLocation!) {
        self.insertEventViaDelegate(.Searching, location: searchingLocation, transportationMode: 0);
        print("Delegate - searchingInPerimeter")
    }

    func didUpdateLocation(location: CLLocation!) {
        // print("Delegate - didUpdateLocation")
    }

    // Mark: Notifications

    func departingViaNotification(notification: NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.Departing, location: tripSegment.departureLocation, transportationMode: 0);
        print("Notification - departing")
    }

    func departedViaNotification(notification: NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.Departed, location: tripSegment.departureLocation, transportationMode: 0);
        print("Notification - departed")
    }

    func departureCanceledViaNotification(notification: NSNotification) {
        self.insertEventViaNotification(.DepartureCanceled, location: CLLocation(), transportationMode: 0);
        print("Notification - departureCanceled")
    }

    func transportationModeViaNotification(notification: NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.TransportMode, location: tripSegment.departureLocation, transportationMode: tripSegment.transportationMode.rawValue);
        print("transportationMode \(tripSegment.transportationMode)")
    }

    func arrivalSuspectedViaNotification(notification: NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.ArrivalSuspected, location: tripSegment.departureLocation, transportationMode: 0);
        print("Notification - arrivalSuspected")
    }

    func arrivedViaNotification(notification: NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.Arrived, location: tripSegment.departureLocation, transportationMode: 0);
        print("Notification - arrived")
    }

    func searchingInPerimeterViaNotification(notification: NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let searchingLocation = userInfo["location"] as! CLLocation
        self.insertEventViaNotification(.Searching, location: searchingLocation, transportationMode: 0);
        print("Notification - searchingInPerimeter")
    }

    // Mark: Core data

    func insertEventViaDelegate(type: PredictIOEventType, location: CLLocation, transportationMode: Int32) {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let event = NSEntityDescription.insertNewObjectForEntityForName("EventViaDelegate", inManagedObjectContext: managedObjectContext) as! EventViaDelegate

        event.latitude = location.coordinate.latitude
        event.longitude = location.coordinate.longitude
        event.accuracy = location.horizontalAccuracy
        event.type = type.rawValue
        event.timeStamp = NSDate()
        event.mode = NSNumber(int: transportationMode);

        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }

    func insertEventViaNotification(type: PredictIOEventType, location: CLLocation, transportationMode: Int32) {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let event = NSEntityDescription.insertNewObjectForEntityForName("EventViaNotification", inManagedObjectContext: managedObjectContext) as! EventViaNotification

        event.latitude = location.coordinate.latitude
        event.longitude = location.coordinate.longitude
        event.accuracy = location.horizontalAccuracy
        event.type = type.rawValue
        event.timeStamp = NSDate()
        event.mode = NSNumber(int: transportationMode)

        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}