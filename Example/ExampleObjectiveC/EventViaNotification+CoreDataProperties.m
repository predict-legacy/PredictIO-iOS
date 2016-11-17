//
//  EventViaNotification+CoreDataProperties.m
//  ExampleObjectiveC
//
//  Created by zee-pk on 17/11/2016.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import "EventViaNotification+CoreDataProperties.h"

@implementation EventViaNotification (CoreDataProperties)

+ (NSFetchRequest<EventViaNotification *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EventViaNotification"];
}

@dynamic accuracy;
@dynamic latitude;
@dynamic longitude;
@dynamic mode;
@dynamic timeStamp;
@dynamic type;
@dynamic zoneType;
@dynamic stationary;

@end
