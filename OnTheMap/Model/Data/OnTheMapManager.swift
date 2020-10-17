//
//  OnTheMapManager.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/27/20.
//

import Foundation

// TODO: Store session, account, public user data, and create student location data here for use thorughout the app
class OnTheMapManager {
    static let shared = OnTheMapManager()
    
    var userId: String!
    var objectId: String!
    var publicUserData: GetPublicUserDataResponse!
    var studentLocations = [StudentLocation]()
}
