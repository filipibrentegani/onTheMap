//
//  AddLocationMapViewController.swift
//  On The Map
//
//  Created by Filipi Brentegani on 20/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController {

    // MARK: - Constants
    
    // MARK: - Enums
    
    // MARK: - Properties
    @IBOutlet private weak var mapView: MKMapView?
    
    lazy private var mapBusiness = MapBusiness()
    
    var studentLocation: StudentLocation?
    var needsRefreshDelegate: NeedsRefreshDelegate?
    var popLastViewController: (() -> ())?
    
    // MARK: - Initializers
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let annotations = mapView?.annotations {
            mapView?.removeAnnotations(annotations)
        }
        let coordinate = CLLocationCoordinate2DMake(studentLocation?.latitude ?? 0, studentLocation?.longitude ?? 0)
        let annotation = MKPointAnnotation()
        annotation.title = "\(studentLocation?.firstName ?? "") \(studentLocation?.lastName ?? "")"
        annotation.subtitle = studentLocation?.mediaURL
        annotation.coordinate = coordinate
        mapView?.addAnnotation(annotation)
        if let annotations = mapView?.annotations {
            mapView?.showAnnotations(annotations, animated: true)
        }
    }
    
    // MARK: - Actions
    @IBAction private func finishAction(_ sender: Any) {
        //TODO add or update the pin
        mapBusiness.updatePin(studentLocation: studentLocation) { [weak self] response in
            do {
                if let _ = try response() {
//                    self?.navigationController?.popViewController(animated: true)
                    self?.dismiss(animated: true, completion: nil)
                    self?.popLastViewController?()
                    self?.needsRefreshDelegate?.needsRefresh()
                }
            } catch {
                print("error: \(error)")
                //TODO show error
            }
        }
    }
    
    @IBAction private func backButtonAction(_ sender: Any) {
        //navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Deinitializers
    
    // MARK: - Extensions


}
