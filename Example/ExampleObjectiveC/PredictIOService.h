//
//  PredictIOService.h
//  ExampleObjectiveC
//
//  Created by ParkTAG on 8/23/16.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PredictIO.h"

typedef NS_ENUM(int, PredictIOEventType) {
    Departing = 0,
    Departed,
    DepartureCanceled,
    TransportMode,
    ArrivalSuspected,
    Arrived,
    Searching
};

@interface PredictIOService : NSObject

- (void)startWithCompletionHandler:(void(^)(NSError *error))handler;
- (void)stop;
- (void)resume;

@end
