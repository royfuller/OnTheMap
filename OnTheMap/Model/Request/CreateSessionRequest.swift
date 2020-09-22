//
//  CreateSessionRequest.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/21/20.
//

import Foundation

struct Udacity: Codable {
    let username: String
    let password: String
}

struct CreateSessionRequest: Codable {
    let udacity: Udacity
}
