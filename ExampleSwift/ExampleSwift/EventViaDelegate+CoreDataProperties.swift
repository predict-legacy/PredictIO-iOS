//
//  EventViaDelegate+CoreDataProperties.swift
//  ExampleSwift
//
//  Created by Zee on 8/23/16.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension EventViaDelegate {

    @NSManaged var accuracy: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var mode: NSNumber?
    @NSManaged var timeStamp: Date?
    @NSManaged var type: NSNumber?

}
