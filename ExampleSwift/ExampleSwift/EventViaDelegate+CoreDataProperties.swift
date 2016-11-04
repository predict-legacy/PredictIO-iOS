//
//  EventViaDelegate+CoreDataProperties.swift
//  ExampleSwift
//
//  Created by zee-pk on 02/09/2016
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData


extension EventViaDelegate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventViaDelegate> {
        return NSFetchRequest<EventViaDelegate>(entityName: "EventViaDelegate");
    }

    @NSManaged public var accuracy: NSNumber?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var mode: NSNumber?
    @NSManaged public var timeStamp: NSDate?
    @NSManaged public var type: NSNumber?

}
