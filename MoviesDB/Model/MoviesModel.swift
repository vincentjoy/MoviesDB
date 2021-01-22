//
//  MoviesModel.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 22/01/21.
//

import Foundation

struct MoviesModel: Codable {
    let totalResults: String
    let Response: String
    let Search: [SearchResult]
}

struct SearchResult: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let movieType: String
    let Poster: String
    
    enum CodingKeys: String, CodingKey {
        case Title, Year, imdbID, Poster
        case movieType = "Type"
    }
}
