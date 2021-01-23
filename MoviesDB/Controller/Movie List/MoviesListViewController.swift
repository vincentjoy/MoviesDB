//
//  MoviesListViewController.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 22/01/21.
//

import UIKit

class MoviesListViewController: UIViewController, UISearchBarDelegate, InputAccessoryProtocol {
    
    @IBOutlet var outletObjects: MoviesListOutletObject!
    
    private var collectionViewDriver: MoviesListCollectionViewDriver?
    private var pageCount = 1
    private var searchText = ""
    private var ongoingPagination = false
    private var isGridView = true
    private lazy var paginationIndicatorHeight: CGFloat = 64
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Movies List"
        collectionViewDriver = MoviesListCollectionViewDriver(cv: outletObjects.collectionView)
        collectionViewDriver?.delegate = self
        
        outletObjects.searchBar.inputAccessoryView = createInputAccessoryView() 
        outletObjects.searchBar.becomeFirstResponder()
    }
    
    @objc func doneTouched() {
        outletObjects.searchBar.resignFirstResponder()
    }

    func fetchMovies() {
        
        if !ongoingPagination {
            outletObjects.loader.startAnimating()
            outletObjects.noResultsView.isHidden = true
        }
        
        Webservice.shared.fetch(method: .Get, url: WebServiceRoute.MoviesListPath(searchText, pageCount), type: MoviesModel.self) { [weak self] (response) in
            
            guard let self = self else {
                return
            }
            
            self.outletObjects.loader.stopAnimating()
            if self.ongoingPagination {
                self.presentPaginationIndicator(false)
            }
            
            switch response {
            case .ResponseObject(let movies):
                if !movies.Search.isEmpty {
                    self.collectionViewDriver?.reloadCV(with: movies.Search, fromPagination: self.ongoingPagination)
                }
            case .Failure(let reason):
                print("Error with reason - \(reason.localizedDescription)")
                self.showNoResponseView()
            default:
                self.showNoResponseView()
            }
            
            self.ongoingPagination = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        if searchText.count==0 {
            self.searchText = ""
            pageCount = 1
            outletObjects.noResultsView.isHidden = true
            collectionViewDriver?.clearList()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            self.searchText = searchText
            pageCount = 1
            fetchMovies()
        }
    }
    
    func showNoResponseView() {
        
        if !ongoingPagination {
            outletObjects.loader.stopAnimating()
            outletObjects.collectionView.isHidden = true
            outletObjects.noResultsView.isHidden = false
        }
    }
    
    @IBAction func restructureUI(_ sender: Any) {
        isGridView = !isGridView
        let buttonTitle = isGridView ? "List" : "Grid"
        outletObjects.changeUIButton.setTitle(buttonTitle, for: .normal)
        collectionViewDriver?.reloadCV(for: isGridView)
    }
    
    @IBAction func retryAction(_ sender: Any) {
        fetchMovies()
    }
}

extension MoviesListViewController: CollectionViewDriverDelegate {
    
    func startPagination() {
        
        if !ongoingPagination {
            ongoingPagination = true
            self.presentPaginationIndicator(true)
            pageCount += 1
            fetchMovies()
        }
    }
    
    func presentPaginationIndicator(_ show: Bool) {
        
        guard searchText.count>0 else {
            return
        }
        
        if show {
            
            outletObjects.paginationIndicatorView.isHidden = false
            outletObjects.paginationIndicator.startAnimating()
            outletObjects.paginationIndicatorBottom.constant = 0
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            
        } else {
            
            outletObjects.paginationIndicatorBottom.constant = -paginationIndicatorHeight
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                self.outletObjects.paginationIndicator.stopAnimating()
                self.outletObjects.paginationIndicatorView.isHidden = true
            }
        }
    }
    
    func refreshList() {
        pageCount = 1
        fetchMovies()
    }
    
    func didSelectItem(with id: String) {
        
        if let detailsVC = storyboard!.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            detailsVC.imdbID = id
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
