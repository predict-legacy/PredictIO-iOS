//
//  SMTWiFiStatus.h
//  testWiFi
//
//  Created by Ali Riahipour on 8/23/16.
//  Copyright © 2016 Snapp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SMTWiFiPoweredState) {
  SMTWiFiPoweredStateUnknown,

  SMTWiFiPoweredStateOn,
  SMTWiFiPoweredStateOff,
};

@interface SMTWiFiStatus : NSObject
/**
 Returns SMTWiFiPoweredStateUnknown if state can not be evaluated (for example for old devices like iPhone 5),
 else returns SMTWiFiPoweredStateOn and SMTWiFiPoweredStateOff accordingly to current WiFi powered state.
 */
+ (SMTWiFiPoweredState) wifiPoweredState;

+ (BOOL)                isWiFiEnabled;
+ (BOOL)                isWiFiConnected;
+ (nullable NSString *) BSSID;
+ (nullable NSString *) SSID;

+ (BOOL)                hotspotEnabled;
@end
