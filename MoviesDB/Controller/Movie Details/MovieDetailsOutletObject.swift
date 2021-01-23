//
//  MovieDetailsOutletObject.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 23/01/21.
//

import UIKit

class MovieDetailsOutletObject: NSObject {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    @IBOutlet weak var movieRated: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var movieActors: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    
    func setupUI(with movieDetails: MovieDetailsModel) {
        
        detailsView.isHidden = false
        
        movieTitle.text = "\(movieDetails.Title) (\(movieDetails.Year))"
        movieDirector.text = "Director: \(movieDetails.Director)"
        movieActors.text = "Actors: \(movieDetails.Actors)"
        moviePlot.text = "\nSynopsis: \(movieDetails.Plot)\n"
        movieRated.text = "Rated: \(movieDetails.Rated)"
        movieLanguage.text = "Language: \(movieDetails.Language)"
        
        DispatchQueue.global().async {
            if let url = URL(string: movieDetails.Poster),
               let data = try? Data(contentsOf: url)  {
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            }
        }
    }
}

