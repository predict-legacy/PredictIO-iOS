//
//  EventViaNotification+CoreDataProperties.h
//  ExampleObjectiveC
//
//  Created by Zee on 02/09/2016.
//  Copyright © 2016 predict.io by ParkTAG GmbH. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EventViaNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventViaNotification (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSDate *timeStamp;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *mode;
@property (nullable, nonatomic, retain) NSNumber *accuracy;

@end

NS_ASSUME_NONNULL_END
