//
//  PinsListViewController.swift
//  On The Map
//
//  Created by Filipi Brentegani on 20/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class PinsListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Constants
    
    // MARK: - Enums
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    // MARK: - Override
    
    // MARK: - Actions
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Deinitializers


}

// MARK: - Extensions

extension PinsListViewController: StudentLocationsUpdateDelegate {
    func reloadScreenData(_ mkPointAnnotations: [MKPointAnnotation]) {
        print("____pins \(mkPointAnnotations)")
    }
}
