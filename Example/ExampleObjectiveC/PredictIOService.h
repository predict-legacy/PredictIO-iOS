//
//  PredictIOService.h
//  ExampleObjectiveC
//
//  Created by zee-pk on 23/08/2016.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <PredictIO-iOS/PredictIO.h>

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
