//
//  PredictIOService.swift
//  ExampleSwift
//
//  Created by zee-pk on 23/08/2016.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import PredictIO

enum PredictIOEventType: Int {
    case departing = 0
    case departed
    case departureCanceled
    case transportMode
    case arrivalSuspected
    case arrived
    case searching
    case stationary
    case traveledByAirplane
}

class PredictIOService: NSObject, PredictIODelegate {

    let apiKey = "YOUR-API-KEY"

    override init() {
        super.init()

        let predictIO = PredictIO.sharedInstance()
        predictIO?.delegate = self
        predictIO?.apiKey = apiKey

        NotificationCenter.default.addObserver(self, selector:#selector(departingViaNotification), name:NSNotification.Name.PIODeparting, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(departedViaNotification), name:NSNotification.Name.PIODeparted, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(departureCanceledViaNotification), name:NSNotification.Name.PIOCanceledDeparture, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(transportationModeViaNotification), name:NSNotification.Name.PIODetectedTransportationMode, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(arrivalSuspectedViaNotification), name:NSNotification.Name.PIOSuspectedArrival, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(arrivedViaNotification), name:NSNotification.Name.PIOArrived, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(searchingInPerimeterViaNotification), name:NSNotification.Name.PIOSearchingParking, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(stationaryAfterArrivalViaNotification), name:NSNotification.Name.PIOBeingStationaryAfterArrival, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(traveledByAirplaneViaNotification), name:NSNotification.Name.PIOTraveledByAirplane, object:nil)
    }

    func resume() -> Void {
        // Check if PredictIO was set to run on every app launch
        let defaults = UserDefaults.standard
        let predictIOEnabled = defaults.bool(forKey: "PredictIOEnabled")
        if predictIOEnabled {
            PredictIO.sharedInstance().start(completionHandler: { (error) -> (Void) in
                if error != nil {
                    OperationQueue.main.addOperation({
                        let userInfo = error!._userInfo as! NSDictionary
                        let errorTitle = userInfo["NSLocalizedFailureReason"] as! String
                        let errorDescription = userInfo["NSLocalizedDescription"] as! String
                        let rootViewController = UIApplication.shared.keyWindow?.rootViewController;
                        let alertController = UIAlertController(title: errorTitle, message: errorDescription, preferredStyle: .alert)
                        let alertActionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertActionOK)
                        rootViewController!.present(alertController, animated: true, completion: nil)
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

    func startWithCompletionHandler(_ handler: @escaping (_ error: Error?) -> (Void) ) -> Void {
        PredictIO.sharedInstance().start(completionHandler: handler)
        // set to run PredictIO on every app launch
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "PredictIOEnabled")
        defaults.synchronize()
    }

    func stop() -> Void {
        PredictIO.sharedInstance().stop()
        // unset to run PredictIO on next app launch
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "PredictIOEnabled")
        defaults.synchronize()
    }

    // Mark - PredictIO Delegate methods

    func departing(_ tripSegment: PIOTripSegment!) {
        self.insertEventViaDelegate(.departing, location: tripSegment.departureLocation, transportationMode: tripSegment.transportationMode);
        print("Delegate - departing")
    }

    func departed(_ tripSegment: PIOTripSegment) {
        self.insertEventViaDelegate(.departed, location: tripSegment.departureLocation, transportationMode: tripSegment.transportationMode);
        print("Delegate - departed")
    }

    func departureCanceled(_ tripSegment: PIOTripSegment) {
        self.insertEventViaDelegate(.departureCanceled, location: tripSegment.departureLocation, transportationMode: tripSegment.transportationMode);
        print("Delegate - departureCanceled")
    }

    func transportationMode(_ tripSegment: PIOTripSegment) {
        self.insertEventViaDelegate(.transportMode, location: tripSegment.departureLocation, transportationMode: tripSegment.transportationMode);
        print("Delegate - transportationMode \(tripSegment.transportationMode.rawValue)")
    }

    func arrivalSuspected(_ tripSegment: PIOTripSegment) {
        self.insertEventViaDelegate(.arrivalSuspected, location: tripSegment.arrivalLocation, transportationMode: tripSegment.transportationMode);
        print("Delegate - arrivalSuspected")
    }

    func arrived(_ tripSegment: PIOTripSegment) {
        self.insertEventViaDelegate(.arrived, location: tripSegment.arrivalLocation, transportationMode: tripSegment.transportationMode);
        print("Delegate - arrived")
    }

    func searching(inPerimeter searchingLocation: CLLocation!) {
        self.insertEventViaDelegate(.searching, location: searchingLocation, transportationMode: TransportationMode.undetermined);
        print("Delegate - searchingInPerimeter")
    }

    func didUpdate(_ location: CLLocation!) {
        // print("Delegate - didUpdateLocation")
    }
    
    func beingStationary(afterArrival tripSegment: PIOTripSegment!) {
        self.insertEventViaDelegate(.stationary, location: tripSegment.arrivalLocation, transportationMode: tripSegment.transportationMode);
        print("Delegate - searchingInPerimeter")
    }

    func traveled(byAirplane tripSegment: PIOTripSegment!) {
        self.insertEventViaDelegate(.traveledByAirplane, location: tripSegment.arrivalLocation, transportationMode: tripSegment.transportationMode);
        print("Delegate - searchingInPerimeter")
    }
    
    // Mark: Notifications

    func departingViaNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.departing, location: tripSegment.departureLocation, transportationMode: tripSegment.transportationMode);
        print("Notification - departing")
    }

    func departedViaNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.departed, location: tripSegment.departureLocation, transportationMode: tripSegment.transportationMode);
        print("Notification - departed")
    }

    func departureCanceledViaNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.departureCanceled, location: tripSegment.departureLocation, transportationMode: tripSegment.transportationMode);
        print("Notification - departureCanceled")
    }

    func transportationModeViaNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.transportMode, location: tripSegment.departureLocation, transportationMode: tripSegment.transportationMode);
        print("transportationMode \(tripSegment.transportationMode)")
    }

    func arrivalSuspectedViaNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.arrivalSuspected, location: tripSegment.arrivalLocation, transportationMode: tripSegment.transportationMode);
        print("Notification - arrivalSuspected")
    }

    func arrivedViaNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.arrived, location: tripSegment.arrivalLocation, transportationMode: tripSegment.transportationMode);
        print("Notification - arrived")
    }

    func searchingInPerimeterViaNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo! as NSDictionary
        let searchingLocation = userInfo["location"] as! CLLocation
        self.insertEventViaNotification(.searching, location: searchingLocation, transportationMode: TransportationMode.undetermined);
        print("!Notification - searchingInPerimeter")
    }

    func stationaryAfterArrivalViaNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.stationary, location: tripSegment.arrivalLocation, transportationMode: tripSegment.transportationMode);
        print("Notification - arrived")
    }

    func traveledByAirplaneViaNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo! as NSDictionary
        let tripSegment = userInfo["tripSegment"] as! PIOTripSegment
        self.insertEventViaNotification(.traveledByAirplane, location: tripSegment.arrivalLocation, transportationMode: tripSegment.transportationMode);
        print("Notification - arrived")
    }
    
    // Mark: Core data

    func insertEventViaDelegate(_ type: PredictIOEventType, location: CLLocation, transportationMode: TransportationMode) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let event = NSEntityDescription.insertNewObject(forEntityName: "EventViaDelegate", into: managedObjectContext) as! EventViaDelegate

        event.latitude = location.coordinate.latitude as NSNumber?
        event.longitude = location.coordinate.longitude as NSNumber?
        event.accuracy = location.horizontalAccuracy as NSNumber?
        event.type = type.rawValue as NSNumber?
        event.timeStamp = Date() as NSDate?
        event.mode = NSNumber(value: transportationMode.rawValue as Int32);

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

    func insertEventViaNotification(_ type: PredictIOEventType, location: CLLocation, transportationMode: TransportationMode) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let event = NSEntityDescription.insertNewObject(forEntityName: "EventViaNotification", into: managedObjectContext) as! EventViaNotification

        event.latitude = location.coordinate.latitude as NSNumber?
        event.longitude = location.coordinate.longitude as NSNumber?
        event.accuracy = location.horizontalAccuracy as NSNumber?
        event.type = type.rawValue as NSNumber?
        event.timeStamp = Date() as NSDate?
        event.mode = NSNumber(value: transportationMode.rawValue as Int32)

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
