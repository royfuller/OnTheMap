//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/21/20.
//

import Foundation

class OnTheMapClient {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations
        
        var stringValue: String {
            switch self {
            case .getStudentLocations: return Endpoints.base + "/StudentLocation"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }

    class func getStudentLocations() {
        let task = URLSession.shared.dataTask(with: Endpoints.getStudentLocations.url) { (data, response, error) in
            guard let data = data else {
                print(error!)
                return
            }
            let decoder = JSONDecoder()
            do {
                let studentLocationsResponseObject = try decoder.decode(GetStudentLocationsResponse.self, from: data)
                print(studentLocationsResponseObject)
            } catch {
                print(error)
            }
        }
        task.resume()
    }

}
