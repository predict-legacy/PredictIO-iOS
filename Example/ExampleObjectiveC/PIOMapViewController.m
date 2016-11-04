//
//  MapViewController.m
//  ExampleObjectiveC
//
//  Created by zee-pk on 31/08/2016.
//  Copyright © 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import "PIOMapViewController.h"
#import <MapKit/MapKit.h>

@interface PIOMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation PIOMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Location";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    CLLocationCoordinate2D coordinate = self.location.coordinate;

    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:@"Event location"]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];

    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:self.location.horizontalAccuracy];
    [self.mapView addOverlay:circle];

    CLLocationDegrees coordinateDelta = 0.003;
    MKCoordinateSpan span = MKCoordinateSpanMake(coordinateDelta, coordinateDelta);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]){
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.05];
        circleRenderer.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        circleRenderer.lineWidth = 4;
        return circleRenderer;
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView = nil;
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"temp"];
        annotationView.canShowCallout = YES;
    }

    return annotationView;
}

@end
