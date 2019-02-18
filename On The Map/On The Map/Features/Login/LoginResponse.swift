//
//  LoginResponse.swift
//  On The Map
//
//  Created by Filipi Brentegani on 17/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {

    var account: Account
    var session: Session
}

struct Account: Codable {
    var key: String
    var registered: Bool
}

struct Session: Codable {
    var id: String
    var expiration: String
}
