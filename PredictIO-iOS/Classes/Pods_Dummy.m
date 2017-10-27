//
//  PodsDummy_PredictIO.m
//  Pods
//
//  Created by Abdul Haseeb on 26/09/2016.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//  SDK Version 3.1.0

#import <Foundation/Foundation.h>

/**
 A bug exists in CocoaPods which causes header files to be missing in installed pods
 whenever the pod is distributed as a static library and corresponding headers.

 As such we include this empty implementation file to ensure that CocoaPods correctly
 generates a target with the HEADER_SEARCH_PATHS property correctly set.

 Some additional info can be found on the following issues:
 - https://github.com/CocoaPods/CocoaPods/issues/3499
 - https://github.com/CocoaPods/CocoaPods/issues/5357
 */
