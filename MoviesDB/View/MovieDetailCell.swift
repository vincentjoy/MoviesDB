//
//  MovieDetailCell.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 22/01/21.
//

import UIKit

class MovieDetailCell: UICollectionViewCell {
    
    static let identifier = "MovieDetailCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    func configureCell(with movie: MoviesViewModel) {
        
        imageView.image = movie.moviePoster
        movieName.text = movie.name
        movieDescription.text = movie.description
    }
    
    func failedLoading() {
        
        /* Show the place holer image here or handle the failed download case */
    }
}
