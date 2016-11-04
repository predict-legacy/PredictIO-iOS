//
//  PIONotificationViewController.m
//  ExampleObjectiveC
//
//  Created by zee-pk on 26/08/2016.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIONotificationViewController.h"
#import "AppDelegate.h"
#import "EventViaNotification.h"
#import "PIOMapViewController.h"

@interface PIONotificationViewController ()

@property (strong, nonatomic) PredictIOService *predictIOService;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSArray *transportationModeLabels;
@property (strong, nonatomic) NSArray *labels;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation PIONotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    self.predictIOService = appDelegate.predictIOService;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd/MM hh:mm a";
    self.labels = @[@"Departing", @"Departed", @"Departure Cancel", @"STMP Callback", @"Arrival Suspected", @"Arrived", @"Searching in perimeter"];
    self.transportationModeLabels = @[@"TransportationMode: Undetermined", @"TransportationMode: Car", @"TransportationMode: NonCar"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL predictIOEnabled = [defaults boolForKey:@"PredictIOEnabled"];
    self.navigationItem.rightBarButtonItem.title = predictIOEnabled ? @"Stop" : @"Start";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showOnMap"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EventViaNotification *event = (EventViaNotification *) [[self fetchedResultsController] objectAtIndexPath:indexPath];
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(event.latitude.doubleValue, event.longitude.doubleValue) altitude:0.0 horizontalAccuracy:event.accuracy.doubleValue verticalAccuracy:0.0 course:0.0 speed:0.0 timestamp:event.timeStamp];
        PIOMapViewController *controller = [segue destinationViewController];
        controller.location = location;
    }
}

- (IBAction)startStopPredictIO:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL predictIOEnabled = [defaults boolForKey:@"PredictIOEnabled"];
    if (predictIOEnabled) {
        self.navigationItem.rightBarButtonItem.title = @"Start";
        [self.predictIOService stop];
    } else {
        self.navigationItem.rightBarButtonItem.title = @"Stop";
        [self.predictIOService startWithCompletionHandler:^(NSError *error) {
            if (error) {
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    NSString *errorTitle = error.userInfo[@"NSLocalizedFailureReason"];
                    NSString *errorDescription = error.userInfo[@"NSLocalizedDescription"];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:errorTitle
                                                                                             message:errorDescription
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *alertActionOK = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:nil];
                    [alertController addAction:alertActionOK];
                    [self presentViewController:alertController animated:YES completion:nil];
                    self.navigationItem.rightBarButtonItem.title = @"Start";
                    NSLog(@"<predict.io> API Key: %@ %@", errorTitle, errorDescription);
                    [defaults setBool:NO forKey:@"PredictIOEnabled"];
                    [defaults synchronize];
                }];
            } else {
                NSLog(@"Started predict.io...");
            }
        }];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[(NSUInteger) section];
    return sectionInfo.numberOfObjects;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
    NSString *build = infoDictionary[@"CFBundleVersion"];
    NSString *version = [PredictIO sharedInstance].version;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"SDK %@", version];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Build %@", build];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self configureCell:cell withEvent:(EventViaNotification *)object];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)configureCell:(UITableViewCell *)cell withEvent:(EventViaNotification *)event {
    enum PredictIOEventType eventType = (enum PredictIOEventType) event.type.integerValue;
    if (eventType == TransportMode) {
        cell.textLabel.text = self.transportationModeLabels[(NSUInteger) event.mode.integerValue];
    } else {
        cell.textLabel.text = self.labels[eventType];
    }
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:event.timeStamp];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showOnMap" sender:self];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EventViaNotification" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:(EventViaNotification *)anObject];
            break;

        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
