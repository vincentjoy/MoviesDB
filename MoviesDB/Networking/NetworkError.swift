//
//  NetworkError.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 22/01/21.
//

import Foundation

enum NetworkError: Error {
    
    case malformedURL, parameterEncodingFailed, authenticationError, badRequest, failed, noResponseData, unableToDecodeResponseData
    
    var localizedDescription: String {
        
        var message = "Unknown Error"
        
        switch self {
        case .malformedURL:
            message = "Malformed URL"
        case .parameterEncodingFailed:
            message = "Failed to encode request parameters"
        case .authenticationError:
            message = "Authenticatioon failed"
        case .badRequest:
            message = "Bad request"
        case .failed:
            message = "API request failed"
        case .noResponseData:
            message = "Empty response data"
        case .unableToDecodeResponseData:
            message = "Unable to decode response object"
        }
        return message
    }
}
