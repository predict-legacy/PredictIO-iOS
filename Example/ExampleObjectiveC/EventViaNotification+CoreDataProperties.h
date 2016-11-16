//
//  EventViaNotification+CoreDataProperties.h
//  ExampleObjectiveC
//
//  Created by Abdul Haseeb on 11/16/16.
//  Copyright © 2016 predict.io by ParkTAG GmbH. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EventViaNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventViaNotification (CoreDataProperties)

+ (NSFetchRequest<EventViaNotification *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *accuracy;
@property (nullable, nonatomic, copy) NSNumber *latitude;
@property (nullable, nonatomic, copy) NSNumber *longitude;
@property (nullable, nonatomic, copy) NSNumber *mode;
@property (nullable, nonatomic, copy) NSDate *timeStamp;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, copy) NSNumber *stationary;

@end

NS_ASSUME_NONNULL_END
