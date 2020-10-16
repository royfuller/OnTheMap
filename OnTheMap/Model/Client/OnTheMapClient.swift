//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/21/20.
//

import Foundation

// TODO: Combine GET/POST code into generic methods
class OnTheMapClient {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations
        case createStudentLocation
        case updateStudentLocation(String)
        case createSession
        case deleteSession
        case getPublicUserData(String)
        
        // TODO: Cleanup/combine simmilar cases
        var stringValue: String {
            switch self {
            case .getStudentLocations: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .createStudentLocation: return Endpoints.base + "/StudentLocation"
            case .updateStudentLocation(let objectId): return Endpoints.base + "/StudentLocation/\(objectId)"
            case .createSession: return Endpoints.base + "/session"
            case .deleteSession: return Endpoints.base + "/session"
            case .getPublicUserData(let userId): return Endpoints.base + "/users/\(userId)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }

    // TODO: Error handling
    class func getStudentLocations(completionHandler: @escaping ([StudentLocation], Error?) -> Void){
        let task = URLSession.shared.dataTask(with: Endpoints.getStudentLocations.url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(GetStudentLocationsResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseObject.results, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([], error)
                }
                return
            }
        }
        task.resume()
    }
    
    // TODO: Error handling
    class func createStudentLocation(studentLocation: StudentLocation, completionHandler: @escaping (Error?) -> Void) {
        var request = URLRequest(url: Endpoints.createStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(studentLocation)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error!)
                DispatchQueue.main.async {
                    completionHandler(error) // TODO: What should happen if the create call fails?
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(CreateStudentLocationResponse.self, from: data)
                OnTheMapManager.shared.objectId = responseObject.objectId
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            }
        }
        task.resume()
    }
    
    // TODO: Error handling
    class func updateStudentLocation(objectId: String, newStudentLocation: StudentLocation, completionHandler: @escaping (Error?) -> Void) {
        var request = URLRequest(url: Endpoints.updateStudentLocation(objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(newStudentLocation)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(error!)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
        task.resume()
    }

    class func createSession(username: String, password: String, completionHandler: @escaping (String?, String?) -> Void) {
        var request = URLRequest(url: Endpoints.createSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = CreateSessionRequest.init(udacity: Udacity(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(nil, error?.localizedDescription)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(CreateSessionResponse.self, from: subsetResponseData(data: data!))
                DispatchQueue.main.async {
                        completionHandler(responseObject.account.key, nil)
                }
            } catch {
                // TODO: Consider breaking out into utility method
                do {
                    let errorResponseObject = try decoder.decode(CreateSessionErrorResponse.self, from: subsetResponseData(data: data!))
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponseObject.error)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error.localizedDescription)
                    }
                    return
                }
            }
        }
        task.resume()
    }
    
    class func deleteSession() {
        var request = URLRequest(url: Endpoints.deleteSession.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            SessionManager.shared.account = nil
            SessionManager.shared.session = nil
        }
        task.resume()
    }
    
    // TODO: Error handling
    class func getPublicUserData(userId: String, completionHandler: @escaping (GetPublicUserDataResponse?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: Endpoints.getPublicUserData(userId).url) { (data, response, error) in
            if error != nil { // TODO: Handle error...
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(GetPublicUserDataResponse.self, from: subsetResponseData(data: data!))
                DispatchQueue.main.async {
                    completionHandler(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
        }
        task.resume()
    }

    class func subsetResponseData(data: Data) -> Data {
        let range = 5..<data.count
        return data.subdata(in: range)
    }
}
