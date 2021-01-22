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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Movies List"
        collectionViewDriver = MoviesListCollectionViewDriver(cv: outletObjects.collectionView)
        
        outletObjects.searchBar.inputAccessoryView = createInputAccessoryView() 
        outletObjects.searchBar.becomeFirstResponder()
    }
    
    @objc func doneTouched() {
        outletObjects.searchBar.resignFirstResponder()
    }

    func fetchMovies() {
        
        Webservice.shared.fetch(method: .Get, url: WebServiceRoute.MoviesListPath(searchText, pageCount), type: MoviesModel.self) { [weak self] (response) in
            
            switch response {
            case .ResponseObject(let movies):
                if !movies.Search.isEmpty {
                    self?.collectionViewDriver?.reloadCV(with: movies.Search)
                }
            case .Failure(let reason):
                print("Error with reason - \(reason.localizedDescription)")
            default:
                print("Default")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        if searchText.count==0 {
            self.searchText = ""
            collectionViewDriver?.clearList()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            self.searchText = searchText
            fetchMovies()
        }
    }
}
