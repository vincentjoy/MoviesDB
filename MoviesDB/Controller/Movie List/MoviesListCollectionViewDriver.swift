//
//  MoviesListCollectionViewDriver.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 22/01/21.
//

import UIKit

protocol CollectionViewDriverDelegate: class {
    func startPagination()
    func refreshList()
    func didSelectItem(with id: String)
}

class MoviesListCollectionViewDriver: NSObject {

    weak var delegate: CollectionViewDriverDelegate?
    let collectionView: UICollectionView
    var movieData = [MoviesViewModel]()
    var isGridView = true
    let pendingOperations = PendingOperations()
    let imageCache = NSCache<NSString, UIImage>()
    var refreshControl: UIRefreshControl?
    
    init(cv: UICollectionView) {
        self.collectionView = cv
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 44, right: 8)
        
        collectionView.alwaysBounceVertical = true
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refreshStream), for: .valueChanged)

        refreshControl = refresher
        collectionView.addSubview(refreshControl!)
    }
    
    @objc func refreshStream() {
        refreshControl?.beginRefreshing()
        self.delegate?.refreshList()
        refreshControl?.endRefreshing()

    }
    
    func reloadCV(with movies: [SearchResult], fromPagination: Bool) {
        
        if !fromPagination {
            movieData.removeAll()
        }
        for movie in movies {
            movieData.append(MoviesViewModel(movie: movie))
        }
        collectionView.isHidden = false
        self.collectionView.reloadData()
    }
    
    func reloadCV(for gridView: Bool) {
        
        self.isGridView = gridView
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
        let selectedID = movieData[indexPath.item].imdbID
        self.delegate?.didSelectItem(with: selectedID)
    }
}

extension MoviesListCollectionViewDriver: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 8
        let titleHeight: CGFloat = 44
        
        var cellWidth: CGFloat
        var cellHeight: CGFloat
        
        if isGridView {
            cellWidth = UIScreen.main.bounds.size.width/3 - (4*padding)
            cellHeight = cellWidth + (0.25*cellWidth) + titleHeight
        } else {
            cellWidth = UIScreen.main.bounds.size.width - (2*padding)
            cellHeight = cellWidth/2 + titleHeight
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension MoviesListCollectionViewDriver: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            self.delegate?.startPagination()
        }
    }
}
