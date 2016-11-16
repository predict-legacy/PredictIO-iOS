//
//  MapViewController.swift
//  ExampleSwift
//
//  Created by zee-pk on 08/09/2016.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import MapKit
import PredictIO

class PIOMapViewController: UIViewController, MKMapViewDelegate {
    
    var location: CLLocation!
    var zoneType = PIOZoneType.other
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var zoneView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Location"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let coordinate = self.location.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Event location" //You can set the subtitle too
        mapView.addAnnotation(annotation)
        
        mapView.add(MKCircle(center: coordinate, radius: self.location.horizontalAccuracy))
        
        let coordinateDelta:CLLocationDegrees = 0.003
        let span = MKCoordinateSpanMake(coordinateDelta, coordinateDelta)
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated: true)
        
        // display zone information if available
        switch zoneType {
        case .other:
            zoneView.isHidden = true
            break
        case .home:
            zoneLabel.text = "Event triggered within Home zone"
            zoneView.isHidden = false
            break
        case .work:
            zoneLabel.text = "Event triggered within Work zone"
            zoneView.isHidden = false
            break
        }
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
