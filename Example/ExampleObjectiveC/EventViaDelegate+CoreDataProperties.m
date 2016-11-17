//
//  EventViaDelegate+CoreDataProperties.m
//  ExampleObjectiveC
//
//  Created by zee-pk on 17/11/2016.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
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
@dynamic zoneType;

@end
