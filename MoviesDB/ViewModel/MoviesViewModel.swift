//
//  MoviesViewModel.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 22/01/21.
//

import UIKit

enum MovieModelState {
    case New, Downloaded, Failed
}

class MoviesViewModel {
    
    let name: String
    let description: String
    
    var moviePosterURL: URL?
    var moviePoster: UIImage?
    var state = MovieModelState.New
    
    init(movie: SearchResult) {
        self.name = movie.Title
        self.description = "\(movie.movieType) released on \(movie.Year)"
        if movie.Poster.isValidURL {
            self.moviePosterURL = URL(string: movie.Poster)
        }
    }
}

extension String {
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
