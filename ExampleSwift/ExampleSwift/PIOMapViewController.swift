//
//  MapViewController.swift
//  ExampleSwift
//
//  Created by Abdul Haseeb on 9/8/16.
//  Copyright © 2016 Abdul Haseeb. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import MapKit

class PIOMapViewController: UIViewController, MKMapViewDelegate {
    
    var location: CLLocation!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Location"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.delegate = self;
        let coordinate = self.location.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Event location" //You can set the subtitle too
        self.mapView.addAnnotation(annotation)
        
        mapView.add(MKCircle(center: coordinate, radius: self.location.horizontalAccuracy))
        
        let coordinateDelta:CLLocationDegrees = 0.003
        let span = MKCoordinateSpanMake(coordinateDelta, coordinateDelta)
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKCircle) {
            let circleRenderer = MKCircleRenderer.init(circle: overlay as! MKCircle)
            circleRenderer.fillColor = UIColor.green.withAlphaComponent(0.05)
            circleRenderer.strokeColor = UIColor.green.withAlphaComponent(0.3)
            circleRenderer.lineWidth = 4
            return circleRenderer
        }
        return MKPolylineRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView? = nil
        if !(annotation is MKUserLocation) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "temp")
            annotationView!.canShowCallout = true
        }
        return annotationView!
    }
}
