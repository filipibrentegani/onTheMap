//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Filipi Brentegani on 20/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    // MARK: - Constants
    
    // MARK: - Enums
    
    // MARK: - Properties
    @IBOutlet private weak var addressTextField: UITextField?
    @IBOutlet private weak var linkTextField: UITextField?
    
    var needsRefreshDelegate: NeedsRefreshDelegate?
    var studentLocation: StudentLocation?
    lazy var clGeocoder = CLGeocoder()
    
    // MARK: - Initializers
    
    // MARK: - Override
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowLocation" {
            if let viewController = segue.destination as? AddLocationMapViewController {
                viewController.needsRefreshDelegate = needsRefreshDelegate
                viewController.studentLocation = studentLocation
                viewController.popLastViewController = popViewController
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelAction(_ sender: Any) {
        popViewController()
    }
    
    @IBAction func findLocationAction(_ sender: Any) {
        clGeocoder.geocodeAddressString(addressTextField?.text ?? "") { [weak self] (pins, error) in
            
            if let error = error {
                print(error)
            } else {
                if let pins = pins, pins.count > 0, let pin = pins.first?.location {
                    self?.studentLocation = self?.createStudentLocation(pin)
                    self?.performSegue(withIdentifier: "ShowLocation", sender: nil)
                } else {
                    //TODO No has locations
                }
            }
        }
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    private func createStudentLocation(_ location : CLLocation) -> StudentLocation {
        let tempLocation = StudentLocation.init(objectId: "", uniqueKey: "", firstName: "", lastName: "", mapString: addressTextField?.text, mediaURL: linkTextField?.text, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, createdAt: "", updatedAt: "")
//        var studentInfo = [
//            "uniqueKey": "", //TODO get from login
//            "firstName": "", //TODO get from login
//            "lastName": "", //TODO get from login
//            "mapString": addressTextField?.text ?? "",
//            "mediaURL": linkTextField?.text ?? "",
//            "latitude": location.coordinate.latitude,
//            "longitude": location.coordinate.longitude,
//            ] as [String: AnyObject]
        
        
//        studentInfo["objectId"] = locationID as AnyObject //TODO fill only if already exists a location
        
        return tempLocation
    }
    
    private func popViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Deinitializers
    
    // MARK: - Extensions


}
