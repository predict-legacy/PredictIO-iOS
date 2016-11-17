//
//  PIOZoneViewController.h
//  ExampleObjectiveC
//
//  Created by Abdul Haseeb on 11/17/16.
//  Copyright © 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PredictIO-iOS/PredictIO.h>

@interface PIOZoneViewController : UIViewController

@property (strong, nonatomic) PIOZone *homeZone;
@property (strong, nonatomic) PIOZone *workZone;

@end
