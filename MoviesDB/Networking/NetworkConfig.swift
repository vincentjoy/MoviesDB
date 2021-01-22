//
//  NetworkConfig.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 22/01/21.
//

import Foundation

enum WebServiceCompletion<T> {
    case ResponseObject(T)
    case ResponseArray([T])
    case Failure(NetworkError)
}

enum HTTPMethod: String {
    case Get = "GET"
    case Post = "POST"
    case Put = "PUT"
    case Patch = "PATCH"
    case Delete = "DELETE"
}

enum WebServiceEndPoint: String {
    case APIKey = "2ca7836d"
    case BaseURL = "http://www.omdbapi.com/"
}

enum WebServiceRoute {
    
    case MoviesListPath(String,Int)
    case MoviesDetailsPath(String)
    
    var Route: String {
        
        let baseURL = WebServiceEndPoint.BaseURL.rawValue
        let apiKey = WebServiceEndPoint.APIKey.rawValue
        
        switch self {
        case let .MoviesListPath(searchString, pageNo):
            let path = "\(apiKey)&s=\(searchString)&page=\(pageNo)"
            return "\(baseURL)?apikey=\(path)"
        case .MoviesDetailsPath(let imdbID):
            return "\(baseURL)?i=\(imdbID)&apikey=\(apiKey)"
        }
    }
}
