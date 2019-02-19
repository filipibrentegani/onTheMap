//
//  MapBusiness.swift
//  On The Map
//
//  Created by Filipi Brentegani on 18/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import MapKit

typealias MapPointsCallback = (() throws -> [MKPointAnnotation]?) -> Void

class MapBusiness {
    
    func requestLogin(completion: @escaping MapPointsCallback) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion { throw error! }
                }
            }
            if let data = data {
                do {
                    let studentLocationResponse: StudentLocationResponse = try JSONDecoder().decode(StudentLocationResponse.self, from: data)
                    
                    let mkPoints = self.createMKPoints(studentLocationResponse)
                    
                    DispatchQueue.main.async {
                        completion { mkPoints }
                    }
                } catch {
                    completion { throw error }
                }
            }
        }
        
        task.resume()
    }
    
    fileprivate func createMKPoints(_ studentLocationResponse: StudentLocationResponse) -> [MKPointAnnotation] {
        var mkPoints = [MKPointAnnotation]()
        for studentLocation in studentLocationResponse.results {
            
            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName
            let last = studentLocation.lastName
            let mediaURL = studentLocation.mediaURL
            
            let mkPoint = MKPointAnnotation()
            mkPoint.coordinate = coordinate
            mkPoint.title = "\(first) \(last)"
            mkPoint.subtitle = mediaURL
            
            mkPoints.append(mkPoint)
        }
        return mkPoints
    }
}
