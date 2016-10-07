//
//  DetailViewController.h
//  ExampleObjectiveC
//
//  Created by ParkTAG on 8/23/16.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

