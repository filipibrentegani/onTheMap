//
//  StudentLocationResponse.swift
//  On The Map
//
//  Created by Filipi Brentegani on 18/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

struct StudentLocationResponse: Codable {
    var results: [StudentLocation]
}

struct StudentLocation: Codable {
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
}
