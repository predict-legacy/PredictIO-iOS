//
//  EventViaNotification+CoreDataProperties.m
//  ExampleObjectiveC
//
//  Created by Abdul Haseeb on 11/16/16.
//  Copyright © 2016 predict.io by ParkTAG GmbH. All rights reserved.
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
@dynamic stationary;

@end
