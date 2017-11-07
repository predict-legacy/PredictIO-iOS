//
//  DeviceUID.h
//  predict.io SDK
//
//  Created by Umer on 11/27/15.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUID : NSObject

+ (nonnull NSString *)uid;
+ (nonnull NSString *)appleIFA;
+ (nonnull NSString*)sha256HashFor:(nonnull NSString*)input;

@end
