//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/21/20.
//

import Foundation

struct StudentLocation: Codable {
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    let uniqueKey: String
    let objectId: String?
    let createdAt: String?
    let updatedAt: String?
}
