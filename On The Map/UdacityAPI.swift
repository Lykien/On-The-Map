//
//  UdacityAPI.swift
//  On The Map
//
//  Created by Nils Riebeling on 01.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import Foundation

class UdacityAPI  {
    

    struct Auth{
        
        static var accountId = ""
        static var sessionId = ""
        static var user: User?
    }
    
    

var userSession = ""
    

enum Endpoints {
    static let base = "https://onthemap-api.udacity.com/v1"
    static let resultLimit = "limit="
    static let paginationSkip = "&skip="
    static let resultOrder = "order="
    
    case getStudentLocation(limit: String?, skip: String?, orderBy: String?)
    case addStudentLocation
    case getStudentLocatioById(userId: String)
    case updateStudentLocation(objectId: String)
    case handleSession
    case getUserData(String)

    
    var stringValue: String {
        
        switch self {
        case .getStudentLocation(let limit, let skip, let orderBy): do {
            
            var tmpString = Endpoints.base + "/StudentLocation"
            var first = true
            
            
            if !(limit?.isEmpty ?? true) {
                
                let s = first ? "?" : "&"
                first = false
                tmpString.append(s + Endpoints.resultLimit + limit!)
                
            }
            
            if !(skip?.isEmpty ?? true) {
                
                let s = first ? "?" : "&"
                first = false
                tmpString.append(s + Endpoints.paginationSkip + skip!)
            }
            
            if !(orderBy?.isEmpty ?? true) {
                
                let s = first ? "?" : "&"
                first = false
                tmpString.append(s + Endpoints.resultOrder + orderBy!)
                
            }
            
            return  tmpString}
        case .addStudentLocation: return Endpoints.base + "/StudentLocation"
        case .getStudentLocatioById(let userId): return Endpoints.base + "/StudentLocation?uniqueKey=\(userId)"
        case .updateStudentLocation(let objectId): return Endpoints.base + "/StudentLocation/\(objectId)"
        case .handleSession: return Endpoints.base + "/session"
        case .getUserData(let userId): return Endpoints.base + "/users/\(userId)"
        
        }
    }
    
    var url: URL {

        return URL(string: stringValue)!
    }

}
    //Request User session based on username and password.
    class func getUserSesssion(username: String, password: String, completion: @escaping (Bool, Error?)->Void)  {

        let body = UserSessionRequest(udacity: Credentials(username: username, password: password))
      
        self.taskForPOSTRequest(url: Endpoints.handleSession.url, body: body, responseType: UserSessionResponse.self) { (response, error) in
            
            if let response = response {
                self.Auth.accountId = response.account.key
                self.Auth.sessionId = response.session.id
                
                completion(true, nil)
                
            }else {
         
                completion(false, error)
                
            }
        }
    }
    
    //Request public user data based on the Accound ID
    class func getPublicUserData(completion: @escaping (Bool, Error?)->Void) {
        self.taskForGETRequest(url: Endpoints.getUserData(Auth.accountId).url, responseType: User.self) { (data, error) in
            if let data = data {
                
                self.Auth.accountId = data.key
                self.Auth.user = data
               
                completion(true, nil)
            }
            completion(false, error)
        }

    }
    
    //Requeast all locations form students
    class func getAllStudentLocations(limit: String?, skip: String?, orderBy: String?, completion: @escaping ([StudentLocation], Error?)->Void) {
        self.taskForGETRequest(url: Endpoints.getStudentLocation(limit: limit, skip: skip, orderBy: orderBy).url, responseType: StudentLocationResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, error)
            }else{
                completion([], error)
            }
        }
    }

    //Requests a specific location based on th userID
    class func getStudentLocationById(completion: @escaping ([StudentLocation], Error?)->Void) {
            
        self.taskForGETRequest(url: Endpoints.getStudentLocatioById(userId: Auth.accountId).url, responseType: StudentLocationResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, error)
            }else{
                completion([], error)
            }
        }
    
    }
    
    //Add a new student location
    class func addStudentLocation(studentLocation: StudentLocation,completion: @escaping (Bool, Error?)->Void) {

        self.taskForPOSTRequest(url: Endpoints.addStudentLocation.url, body: studentLocation, responseType: PostStudentResponse.self) { (response, error) in
           
            if response != nil {
                
                completion(true, nil)
                
            }else {
                
                completion(false, error)
                
            }
        }
    }
    
    //Update an existing student location
    class func updateStudentLocation(studentLocation: StudentLocation, completion: @escaping (Bool, Error?)->Void) {
     
        self.taskForPUTRequest(url: Endpoints.updateStudentLocation(objectId: studentLocation.objectId ?? "").url, body: studentLocation, responseType: UpdateStudentLocationResponse.self) { (response, error) in
            if response != nil {
                
                completion(true, nil)
                
            }else{
            
                completion(false, error)
                
            }
        }
    }
    
    //Delete a Session
    class func deleteSession(completion: @escaping (Bool, Error?)->Void) {
        
        var request = URLRequest(url: Endpoints.handleSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard data != nil else {
                
                completion(false, error)
                return
            }
            completion(true, nil)
            self.Auth.sessionId = ""
        }
        task.resume()

    }

    /*
     GetRequest method with special catch block. If there is an DecodingError, then it will try to cut the first 5 chars. Afterwards it will try decoding again.
     
     */
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void)  -> URLSessionTask{
        
        let task = URLSession.shared.dataTask(with: url) {
             data, reponse, error in
             
             guard let data = data else {
                 completion(nil, error)
                 return
             }
            
            let decoder = JSONDecoder()
            
             do{
                let responseObject = try decoder.decode(ResponseType.self, from: data)
            
                DispatchQueue.main.async {
        
                completion(responseObject, nil)
              }
             
             
             }catch DecodingError.dataCorrupted(_){
             
               do{
             
               // let range = Range(5..<data.count)
               let newData = data.subdata(in: 5..<data.count)
              
               let responseObject = try decoder.decode(ResponseType.self, from: newData)
                   
               DispatchQueue.main.async {
                   completion(responseObject, nil)
               }
                   
               }catch {
                       DispatchQueue.main.async {
                       completion(nil, error)
                       }
                   }
             }
             catch {
                    
                    DispatchQueue.main.async {
                     completion(nil, error)
                    }
                }
         }
         task.resume()
        
        return task
    
    }
    
    /*
     PostRequest method with special catch block. If there is an DecodingError, then it will try to cut the first 5 chars. Afterwards it will try decoding again.
     */
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable> (url:URL, body: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
          request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          request.httpBody = try! JSONEncoder().encode(body)
       
          let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
              guard let data = data else {
                  
                completion(nil, error)
                
                  return
              }
            
            let decoder = JSONDecoder()
            
            //Check if decoding to Responstype is working
            do{
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
              }
            //If initial decoding is not working, we try without the first 5 chars
            catch DecodingError.dataCorrupted( _){
              
                do{
              
                // let range = Range(5..<data.count)
                let newData = data.subdata(in: 5..<data.count)
               
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                    
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                    
                }catch {
                        DispatchQueue.main.async {
                        completion(nil, error)
                        }
                    }
              }
              catch {
                DispatchQueue.main.async {
                completion(nil, error)
                }

              }
          }
          
          task.resume()
    }
    
    
    //Method to start a PUT method
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable> (url:URL, body: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        
          request.httpMethod = "PUT"
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          request.httpBody = try! JSONEncoder().encode(body)
        
          let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
           
              guard let data = data else {

                completion(nil, error)
                  return
              }
            
            let decoder = JSONDecoder()
              do{
                let responseObject = try decoder.decode(ResponseType.self, from: data)

                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
              } catch DecodingError.keyNotFound( _, _){
          
                do {
                    let responseObject = try decoder.decode(UdacityErrorResponse.self, from: data)
                 
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                } catch {
                    }
                        DispatchQueue.main.async {
                         completion(nil, error)
                    }
              } catch {
                    DispatchQueue.main.async {
                     completion(nil, error)
                }
            }
          }
          task.resume()
    }

    
}


//Debug JSON - JSON to pretty: Source: https://gist.github.com/cprovatas/5c9f51813bc784ef1d7fcbfb89de74fe
   extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
    

}




