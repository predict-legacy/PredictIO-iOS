//
//  EventViaDelegate+CoreDataProperties.m
//  ExampleObjectiveC
//
//  Created by Abdul Haseeb on 11/16/2016.
//  Copyright © 2016 predict.io by ParkTAG GmbH. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EventViaDelegate+CoreDataProperties.h"

@implementation EventViaDelegate (CoreDataProperties)

+ (NSFetchRequest<EventViaDelegate *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EventViaDelegate"];
}

@dynamic accuracy;
@dynamic latitude;
@dynamic longitude;
@dynamic mode;
@dynamic timeStamp;
@dynamic type;
@dynamic stationary;

@end
