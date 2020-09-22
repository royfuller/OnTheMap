//
//  CreateSessionResponse.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/21/20.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct CreateSessionResponse: Codable {
    let account: Account
    let session: Session
}
