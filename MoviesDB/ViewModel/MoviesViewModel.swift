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
    let moviePosterURL: URL?
    var moviePoster: UIImage?
    var state = MovieModelState.New
    
    init(movie: SearchResult) {
        self.name = movie.Title
        self.description = "\(movie.movieType) released on \(movie.Year)"
        self.moviePosterURL = URL(string: movie.Poster)
    }
}
