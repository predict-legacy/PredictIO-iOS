//
//  PIOZoneViewController.m
//  ExampleObjectiveC
//
//  Created by Abdul Haseeb on 11/17/16.
//  Copyright © 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

#import "PIOZoneViewController.h"
#import <MapKit/MapKit.h>

@interface PIOZoneViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation PIOZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.homeZone) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = self.homeZone.center;
        annotation.title = @"Home Zone";
        [self.mapView addAnnotation:annotation];
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.homeZone.center radius:self.homeZone.radius];
        [self.mapView addOverlay:circle];
    }
    
    if (self.workZone) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = self.workZone.center;
        annotation.title = @"Work Zone";
        [self.mapView addAnnotation:annotation];
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.workZone.center radius:self.workZone.radius];
        [self.mapView addOverlay:circle];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = nil;
    if (!(annotation == mapView.userLocation)) {
        MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"zone"];
        pinAnnotationView.canShowCallout = YES;
        if ([annotation.title isEqualToString:@"Home Zone"]) {
            pinAnnotationView.pinTintColor = [UIColor orangeColor];
        } else {
            pinAnnotationView.pinTintColor = [UIColor purpleColor];
        }
        annotationView = pinAnnotationView;
    }
    return  annotationView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]){
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.05];
        circleRenderer.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        circleRenderer.lineWidth = 4;
        return circleRenderer;
    }
    return nil;
}

@end
