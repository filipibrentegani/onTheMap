//
//  MapViewController.swift
//  On The Map
//
//  Created by Filipi Brentegani on 18/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Constants
    
    // MARK: - Enums
    
    // MARK: - Properties
    @IBOutlet private weak var mapView: MKMapView?
    
    // MARK: - Initializers
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView?.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "AddLocation" {
            if let viewController = segue.destination as? AddLocationViewController, let tabBarController = tabBarController as? NeedsRefreshDelegate {
                viewController.needsRefreshDelegate = tabBarController
            }
        }
    }
    
    // MARK: - Actions
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Deinitializers
}

// MARK: - Extensions
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}

extension MapViewController: StudentLocationsUpdateDelegate {
    func reloadScreenData(_ mkPointAnnotations: [MKPointAnnotation]) {
        mapView?.addAnnotations(mkPointAnnotations)
    }
}
