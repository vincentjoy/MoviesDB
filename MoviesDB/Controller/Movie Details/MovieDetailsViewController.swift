//
//  MovieDetailsViewController.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 23/01/21.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet var outletObjects: MovieDetailsOutletObject!
    
    var imdbID = ""
    var movieDetails: MovieDetailsModel? {
        didSet {
            if let unwrapped = movieDetails {
                outletObjects.setupUI(with: unwrapped)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetails()
    }
    
    func fetchDetails() {
        
        Webservice.shared.fetch(method: .Get, url: WebServiceRoute.MoviesDetailsPath(imdbID), type: MovieDetailsModel.self) { [weak self] (response) in
            
            guard let self = self else {
                return
            }
            
            self.outletObjects.loader.stopAnimating()
            
            switch response {
            case .ResponseObject(let movieDetails):
                self.movieDetails = movieDetails
            case .Failure(let reason):
                print("Error with reason - \(reason.localizedDescription)")
            default:
                print("No results")
            }
        }
    }
}
