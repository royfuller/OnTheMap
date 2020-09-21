//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/21/20.
//

import Foundation

struct StudentLocation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
