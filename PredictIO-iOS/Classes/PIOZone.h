//
//  PIOZone.h
//  PredictIOSDK
//
//  Created by Umer on 09/06/2016.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//  SDK Version 3.2.0
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(int, PIOZoneType) {
    // some arbitrary zone
    PIOZoneTypeOther = 0,
    
    // home zone
    PIOZoneTypeHome,
    
    // work zone
    PIOZoneTypeWork
};

@interface PIOZone : NSObject

@property (assign, readonly) PIOZoneType zoneType;
@property (assign, readonly) CLLocationDistance radius;
@property (assign, readonly) CLLocationCoordinate2D center;

- (instancetype)initWithCenter:(CLLocationCoordinate2D)center
                        radius:(CLLocationDistance)radius
                      zoneType:(PIOZoneType)zoneType;

@end
