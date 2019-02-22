//
//  StudentLocationsUpdateDelegate.swift
//  On The Map
//
//  Created by Filipi Brentegani on 20/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import MapKit

protocol StudentLocationsUpdateDelegate {
    func reloadScreenData(_ mkPointAnnotations: [MKPointAnnotation])
}
