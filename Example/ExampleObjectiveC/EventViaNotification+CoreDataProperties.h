//
//  EventViaNotification+CoreDataProperties.h
//  ExampleObjectiveC
//
//  Created by zee-pk on 17/11/2016.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import "EventViaNotification+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface EventViaNotification (CoreDataProperties)

+ (NSFetchRequest<EventViaNotification *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *accuracy;
@property (nullable, nonatomic, copy) NSNumber *latitude;
@property (nullable, nonatomic, copy) NSNumber *longitude;
@property (nullable, nonatomic, copy) NSNumber *mode;
@property (nullable, nonatomic, copy) NSDate *timeStamp;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, copy) NSNumber *zoneType;
@property (nullable, nonatomic, copy) NSNumber *stationary;

@end

NS_ASSUME_NONNULL_END
