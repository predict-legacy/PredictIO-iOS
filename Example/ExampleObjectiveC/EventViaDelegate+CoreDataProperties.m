//
//  EventViaDelegate+CoreDataProperties.m
//  ExampleObjectiveC
//
//  Created by Abdul Haseeb on 11/16/16.
//  Copyright © 2016 predict.io by ParkTAG GmbH. All rights reserved.
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
@dynamic stationary;
@dynamic timeStamp;
@dynamic type;
@dynamic zoneType;

@end
