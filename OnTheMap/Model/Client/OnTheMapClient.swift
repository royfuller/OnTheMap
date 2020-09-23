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
        case createStudentLocation
        case updateStudentLocation(String)
        case createSession
        case deleteSession
        case getUserData(String)
        
        var stringValue: String {
            switch self {
            case .getStudentLocations: return Endpoints.base + "/StudentLocation?limit=100"
            case .createStudentLocation: return Endpoints.base + "/StudentLocation"
            case .updateStudentLocation(let objectId): return Endpoints.base + "/\(objectId)"
            case .createSession: return Endpoints.base + "/session"
            case .deleteSession: return Endpoints.base + "/session"
            case .getUserData(let userId): return Endpoints.base + "/users/\(userId)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }

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
                print(responseObject)
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
    
    class func createStudentLocation(studentLocation: StudentLocation) {
        var request = URLRequest(url: Endpoints.createStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(studentLocation)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error!)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(CreateStudentLocationResponse.self, from: data)
                print(responseObject)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    class func updateStudentLocation(objectId: String, newStudentLocation: StudentLocation) {
        var request = URLRequest(url: Endpoints.updateStudentLocation(objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(newStudentLocation)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error!)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(CreateStudentLocationResponse.self, from: data)
                print(responseObject)
            } catch {
                print(error)
            }
        }
        task.resume()
    }

    class func createSession(username: String, password: String, completionHandler: @escaping (CreateSessionResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.createSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = CreateSessionRequest.init(udacity: Udacity(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(CreateSessionResponse.self, from: newData!)
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
            if error != nil { // Handle error…
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(DeleteSessionResponse.self, from: newData!)
                print(responseObject)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}
