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
    
    func configureCell(with movie: MoviesViewModel) {
        
        imageView.image = movie.moviePoster
        movieName.text = movie.name
    }
    
    func failedLoading() {
        
        imageView.image = UIImage.init(named: "poster_placeholder.png")
    }
}
