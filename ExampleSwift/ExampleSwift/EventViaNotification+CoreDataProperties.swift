//
//  EventViaNotification+CoreDataProperties.swift
//  ExampleSwift
//
//  Created by Abdul Haseeb on 11/16/16.
//  Copyright © 2016 Abdul Haseeb. All rights reserved.
//

import Foundation
import CoreData


extension EventViaNotification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventViaNotification> {
        return NSFetchRequest<EventViaNotification>(entityName: "EventViaNotification");
    }

    @NSManaged public var accuracy: NSNumber?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var mode: NSNumber?
    @NSManaged public var stationary: NSNumber?
    @NSManaged public var timeStamp: NSDate?
    @NSManaged public var type: NSNumber?
    @NSManaged public var zoneType: NSNumber?

}
