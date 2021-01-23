//
//  Webservice.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 22/01/21.
//

import UIKit

class Webservice {
    
    static let shared = Webservice()
    
    func fetch<T:Codable>(method: HTTPMethod, url: WebServiceRoute, parameters:Any?=nil, type:T.Type, completion: @escaping (WebServiceCompletion<T>) -> ()) {
        
        guard let requestURL = URL(string: url.Route) else {
            DispatchQueue.main.async {
                completion(.Failure(NetworkError.malformedURL))
            }
            return
        }
        
        print(url.Route)
    
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let requestBody = parameters as? [String:Any] {
            guard let serializedParams = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted) else {
                DispatchQueue.main.async {
                    completion(.Failure(NetworkError.parameterEncodingFailed))
                }
                return
            }
            request.httpBody = serializedParams
        }
        
        let task = URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            
            guard (error == nil) else {
                DispatchQueue.main.async {
                    completion(.Failure(NetworkError.failed))
                }
                return
            }
            
            guard let responseData = response as? HTTPURLResponse,
                let receivedData = data else {
                DispatchQueue.main.async {
                    completion(.Failure(NetworkError.noResponseData))
                }
                return
            }
            
            let responseStatus = self.isValidResposne(response: responseData)
            switch responseStatus {
            case .success:
                let jsonDecoder = JSONDecoder()
                if let decodedData = try? jsonDecoder.decode(T.self, from: receivedData) {
                    DispatchQueue.main.async {
                        completion(.ResponseObject(decodedData))
                    }
                } else if let decodedData = try? jsonDecoder.decode([T].self, from: receivedData) {
                    DispatchQueue.main.async {
                        completion(.ResponseArray(decodedData))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.Failure(NetworkError.unableToDecodeResponseData))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.Failure(error))
                }
            }
        }
        task.resume()
    }
    
    func isValidResposne(response: HTTPURLResponse) -> Result<String,NetworkError> {
        switch response.statusCode{
        case 200...299:
            return .success("Valid Response")
        case 401:
            return .failure(NetworkError.authenticationError)
        case 500:
            return .failure(NetworkError.badRequest)
        default:
            return .failure(NetworkError.failed)
        }
    }
}
