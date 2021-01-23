//
//  MoviesListCollectionViewDriver.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 22/01/21.
//

import UIKit

class MoviesListCollectionViewDriver: NSObject {

    let collectionView: UICollectionView
    private var movieData: [MoviesViewModel] = []
    private let pendingOperations = PendingOperations()
    private let imageCache = NSCache<NSString, UIImage>()
    
    init(cv: UICollectionView) {
        self.collectionView = cv
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 44, right: 8)
    }
    
    func reloadCV(with movies: [SearchResult]) {
        
        movieData.removeAll()
        for movie in movies {
            movieData.append(MoviesViewModel(movie: movie))
        }
        collectionView.isHidden = false
        self.collectionView.reloadData()
    }
    
    func clearList() {
        pendingOperations.downloadQueue.cancelAllOperations()
        movieData.removeAll()
        collectionView.isHidden = true
        collectionView.reloadData()
    }
    
    func startDownload(for movieData: MoviesViewModel, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil,
            let url = movieData.moviePosterURL else {
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            
            movieData.moviePoster = cachedImage
            self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            self.collectionView.reloadItems(at: [indexPath])
            
        } else {
            
            let downloader = ImageDownloader(movieData)
            downloader.completionBlock = {
                if downloader.isCancelled {
                    return
                }
                
                DispatchQueue.main.async {
                    self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                    self.collectionView.reloadItems(at: [indexPath])
                    if let downloadedImage = downloader.movieObject.moviePoster {
                        self.imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                    }
                }
            }
            
            pendingOperations.downloadsInProgress[indexPath] = downloader
            pendingOperations.downloadQueue.addOperation(downloader)
        }
    }
}

extension MoviesListCollectionViewDriver: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCell.identifier, for: indexPath) as? MovieDetailCell {
            
            let dataSource = movieData[indexPath.item]
            cell.configureCell(with: dataSource)
            cell.shadowDecorate()
            
            switch (dataSource.state) {
            case .Failed:
                print("Failed at \(indexPath.item)")
                cell.failedLoading()
            case .New:
                startDownload(for: dataSource, at: indexPath)
            case .Downloaded:
                print("Download complete")
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected at \(indexPath.item)")
    }
}

extension MoviesListCollectionViewDriver: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 8
        let cellWidth = UIScreen.main.bounds.size.width/3 - (4*padding)
        let titleHeight: CGFloat = 44
        let cellHeight: CGFloat = cellWidth + (0.25*cellWidth) + titleHeight
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
