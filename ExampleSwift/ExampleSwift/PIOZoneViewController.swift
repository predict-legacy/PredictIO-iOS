//
//  PIOZoneViewController.swift
//  ExampleSwift
//
//  Created by Zee on 16/11/2016.
//  Copyright © 2016 Abdul Haseeb. All rights reserved.
//

import UIKit
import MapKit
import PredictIO

class PIOZoneViewController: UIViewController {
    
    let homeZoneAnnotationTitle = "Home Zone"
    let workZoneAnnotationTitle = "Work Zone"
    
    var homeZone: PIOZone!
    var workZone: PIOZone!

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (homeZone != nil) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = homeZone.center
            annotation.title = homeZoneAnnotationTitle
            mapView.addAnnotation(annotation)
            mapView.add(MKCircle(center: homeZone.center, radius: homeZone.radius))
        }
        
        if (workZone != nil) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = workZone.center
            annotation.title = workZoneAnnotationTitle
            mapView.addAnnotation(annotation)
            mapView.add(MKCircle(center: workZone.center, radius: workZone.radius))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "zone")
            annotationView!.canShowCallout = true
            if (annotation.title! == homeZoneAnnotationTitle) {
                pinAnnotationView.pinTintColor = UIColor.orange
            } else {
                pinAnnotationView.pinTintColor = UIColor.purple
            }
            annotationView = pinAnnotationView
        }
        return annotationView!
    }
}
