//
//  PIOViewController.m
//  PredictIO-iOS
//
//  Created by haseebOptini on 07/18/2016.
//  Copyright (c) 2016 haseebOptini. All rights reserved.
//

#import "PIOViewController.h"
#import "PredictIO.h"
#import "Constants.h"

#define API_KEY       @"260ef48214d69f06c1ad373c1354eab6605cf2792afc82e6e70f402e9cd1acee"
@interface PIOViewController ()<PredictIODelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (readwrite) BOOL parktagEnabled;

@end

@implementation PIOViewController {
    NSMutableArray *tableData;
}
@synthesize tableView=_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    tableData = [[NSMutableArray alloc] init];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(startStopParktag)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=PTCatagoryName;
    return cell;
}

#pragma custom methods

- (void)startStopParktag
{
    PredictIO *pt=[PredictIO sharedInstance];
    
    if (self.parktagEnabled) {
        [pt stop];
        [self.navigationItem.rightBarButtonItem setTitle:@"Start"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"enabled"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.parktagEnabled = NO;
    } else if (API_KEY && ![API_KEY isEqualToString:@"YOUR-API-KEY"]){
        pt.delegate = self;
        pt.apiKey = API_KEY;
        [pt startWithCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", [error description]);
            } else {
                NSLog(@"Started ParkTAG...");
            }
        }];
        [self.navigationItem.rightBarButtonItem setTitle:@"Stop"];
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"enabled"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.parktagEnabled = YES;
    } else {
        NSLog(@">>> ERROR: Please set your API key in API_KEY preprocessor macro.");
    }
}

- (void) addEventName:(NSString *)eventName {
    [tableData addObject:eventName];
    [self.tableView reloadData];
}

#pragma mark - PredictIODelegates

- (void)departingFromLocation:(CLLocation *)departureLocation
                transportMode:(TransportationMode)transportationMode {
    [tableData addObject:PTEventVacatingParking];
}

- (void)departedLocation:(CLLocation *)departureLocation
           departureTime:(NSDate *)departureTime
           transportMode:(TransportationMode)transportationMode {
    [tableData addObject:PTEventVacatedParking];
}

- (void)departureCanceled {
    [self addEventName:PTEventVacatedParkingCancel];
}

- (void)arrivalSuspectedFromLocation:(CLLocation *)departureLocation
                     arrivalLocation:(CLLocation *)arrivalLocation
                       departureTime:(NSDate *)departureTime
                         arrivalTime:(NSDate *)arrivalTime
                       transportMode:(TransportationMode)transportationMode {
    [self addEventName:PTEventParkingSuspected];
}

- (void)arrivedAtLocation:(CLLocation *)arrivalLocation
        departureLocation:(CLLocation *)departureLocation
              arrivalTime:(NSDate *)arrivalTime
            departureTime:(NSDate *)departureTime
            transportMode:(TransportationMode)transportationMode {
    [self addEventName:PTEventVehicleParked];
}

- (void)searchingParking:(CLLocation *)location {
    [self addEventName:PTEventSearchingParking];
}

- (void)didUpdateLocation:(CLLocation *)location {
    [self addEventName:PTEventUpdateLocation];
}

@end
