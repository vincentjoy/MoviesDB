//
//  MoviesListOutletObject.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 22/01/21.
//

import UIKit

class MoviesListOutletObject: NSObject {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var noResultsView: UIView!
    @IBOutlet weak var retryButton: UIView! {
        didSet {
            retryButton.layer.cornerRadius = 5
            retryButton.layer.borderWidth = 0.75
            retryButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var paginationIndicator: UIActivityIndicatorView!
    @IBOutlet weak var paginationIndicatorView: UIView!
    @IBOutlet weak var paginationIndicatorBottom: NSLayoutConstraint!
}
