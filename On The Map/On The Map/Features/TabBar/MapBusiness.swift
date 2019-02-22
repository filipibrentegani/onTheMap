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
typealias UpdatePointCallback = (() throws -> Bool?) -> Void

class MapBusiness {
    
    func requestLocations(completion: @escaping MapPointsCallback) {
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
    
    func updatePin(studentLocation: StudentLocation?, completion: @escaping UpdatePointCallback) {
        if let studentLocation = studentLocation {
            let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
            let url: URL
            if let objectId = studentLocation.objectId {
                url = URL(string: urlString + "/\(objectId)")!
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
                request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = "{\"uniqueKey\": \"\(String(describing: studentLocation.uniqueKey))\", \"firstName\": \"\(String(describing: studentLocation.firstName))\", \"lastName\": \"\(String(describing: studentLocation.lastName))\",\"mapString\": \"\(String(describing: studentLocation.mapString))\", \"mediaURL\": \"\(String(describing: studentLocation.mapString))\",\"latitude\": \(String(describing: studentLocation.latitude)), \"longitude\": \(String(describing: studentLocation.longitude))}".data(using: .utf8)
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response, error in
                    if error != nil {
                        completion { throw error! }
                        return
                    }
                    if let data = data {
                        do {
                            let _: CreatePinResponse = try JSONDecoder().decode(CreatePinResponse.self, from: data)
                            //{"updatedAt":"2019-02-22T01:30:14.947Z"} SUCCESS
                            //{"code":101,"error":"Object not found."} OBJECT NOT FOUND 404
                            
                            DispatchQueue.main.async {
                                completion { true }
                            }
                        } catch {
                            completion { throw error }
                        }
                    }
                }
                task.resume()
            } else {
                url = URL(string: urlString)!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
                request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = "{\"uniqueKey\": \"\(String(describing: studentLocation.uniqueKey))\", \"firstName\": \"\(String(describing: studentLocation.firstName))\", \"lastName\": \"\(String(describing: studentLocation.lastName))\",\"mapString\": \"\(String(describing: studentLocation.mapString))\", \"mediaURL\": \"\(String(describing: studentLocation.mapString))\",\"latitude\": \(String(describing: studentLocation.latitude)), \"longitude\": \(String(describing: studentLocation.longitude))}".data(using: .utf8)
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response, error in
                    if error != nil {
                        completion { throw error! }
                        return
                    }
                    if let data = data {
                        do {
                            let _: UpdatePinResponse = try JSONDecoder().decode(UpdatePinResponse.self, from: data)
                            //{"objectId": "IuWWBxpMmG", "createdAt": "2019-02-22T01:43:37.959Z"}
                            
                            DispatchQueue.main.async {
                                completion { true }
                            }
                        } catch {
                            completion { throw error }
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    fileprivate func createMKPoints(_ studentLocationResponse: StudentLocationResponse) -> [MKPointAnnotation] {
        var mkPoints = [MKPointAnnotation]()
        for studentLocation in studentLocationResponse.results {
            
            let lat = CLLocationDegrees(studentLocation.latitude ?? 0)
            let long = CLLocationDegrees(studentLocation.longitude ?? 0)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName ?? ""
            let last = studentLocation.lastName ?? ""
            let mediaURL = studentLocation.mediaURL ?? ""
            
            let mkPoint = MKPointAnnotation()
            mkPoint.coordinate = coordinate
            mkPoint.title = "\(first) \(last)"
            mkPoint.subtitle = mediaURL
            
            mkPoints.append(mkPoint)
        }
        return mkPoints
    }
}
