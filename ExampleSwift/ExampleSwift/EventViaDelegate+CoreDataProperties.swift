//
//  EventViaDelegate+CoreDataProperties.swift
//  ExampleSwift
//
//  Created by Zee on 24/10/2016.
//  Copyright © 2016 Abdul Haseeb. All rights reserved.
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
