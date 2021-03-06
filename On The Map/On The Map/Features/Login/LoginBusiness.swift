//
//  File.swift
//  On The Map
//
//  Created by Filipi Brentegani on 17/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

typealias LoginCallback = (() throws -> LoginResponse?) -> Void

class LoginBusiness {
    
    func requestLogin(email: String, password: String, completion: @escaping LoginCallback) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion { throw error! }
                }
            }
            let range = 5..<data!.count
            if let newData = data?.subdata(in: range) {/* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                do {
                    let loginResponse: LoginResponse = try JSONDecoder().decode(LoginResponse.self, from: newData)
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.session = loginResponse
                    
//                    DispatchQueue.main.async {
//                        completion { loginResponse }
//                    }
                    self.requestUserInfo(loginResponse, completion: completion)
                } catch {
                    completion { throw error }
                }
            }
        }
        task.resume()
    }
    
    func requestUserInfo(_ loginResponse: LoginResponse, completion: @escaping LoginCallback) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(loginResponse.account.key)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion { throw error! }
                }
            }
            let range = 5..<data!.count
            if let newData = data?.subdata(in: range) {
                print(String(data: newData, encoding: .utf8)!)
                do {
                    let userData: UserDataResponse = try JSONDecoder().decode(UserDataResponse.self, from: newData)
                    
                    DispatchQueue.main.async {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.session = loginResponse
                        appDelegate.userData = userData
                        completion { loginResponse }
                    }
                } catch {
                    completion { throw error }
                }
            }
        }
        task.resume()
    }
}
