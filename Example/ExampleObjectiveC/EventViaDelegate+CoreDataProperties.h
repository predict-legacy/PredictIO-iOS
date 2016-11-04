//
//  EventViaDelegate+CoreDataProperties.h
//  ExampleObjectiveC
//
//  Created by zee-pk on 02/09/2016.
//  Copyright © 2016 predict.io by ParkTAG GmbH. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EventViaDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventViaDelegate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSDate *timeStamp;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *accuracy;
@property (nullable, nonatomic, retain) NSNumber *mode;

@end

NS_ASSUME_NONNULL_END
