//
//  PIOMapViewController.h
//  ExampleObjectiveC
//
//  Created by zee-pk on 31/08/2016.
//  Copyright © 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <PredictIO/PredictIO.h>

@interface PIOMapViewController : UIViewController

@property (strong, nonatomic) CLLocation *location;
@property (assign, nonatomic) PIOZoneType zoneType;

@end
