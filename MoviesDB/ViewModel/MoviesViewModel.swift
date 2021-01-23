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
    
    var moviePosterURL: URL?
    var moviePoster: UIImage?
    var state = MovieModelState.New
    
    init(movie: SearchResult) {
        self.name = "\(movie.Title) - \(movie.Year)"
        if movie.Poster.isValidURL {
            self.moviePosterURL = URL(string: movie.Poster)
        } else {
            state = .Failed
        }
    }
}
