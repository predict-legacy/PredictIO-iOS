//
//  EventViaDelegate+CoreDataProperties.h
//  ExampleObjectiveC
//
//  Created by zee-pk on 17/11/2016.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import "EventViaDelegate+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface EventViaDelegate (CoreDataProperties)

+ (NSFetchRequest<EventViaDelegate *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *accuracy;
@property (nullable, nonatomic, copy) NSNumber *latitude;
@property (nullable, nonatomic, copy) NSNumber *longitude;
@property (nullable, nonatomic, copy) NSNumber *mode;
@property (nullable, nonatomic, copy) NSDate *timeStamp;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, copy) NSNumber *stationary;
@property (nullable, nonatomic, copy) NSNumber *zoneType;

@end

NS_ASSUME_NONNULL_END
