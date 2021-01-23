//
//  ImageOperations.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 22/01/21.
//

import UIKit

class PendingOperations {
    
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        return queue
    }()
}

class ImageDownloader: Operation {
    
    let movieObject: MoviesViewModel
    
    init(_ movieObject: MoviesViewModel) {
        self.movieObject = movieObject
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        guard let url = movieObject.moviePosterURL else {
            movieObject.moviePoster = nil
            movieObject.state = .Failed
            return
        }
        
        guard let imageData = try? Data(contentsOf: url) else { return }
        
        if isCancelled {
            return
        }
        
        if !imageData.isEmpty {
            movieObject.moviePoster = UIImage(data:imageData)
            movieObject.state = .Downloaded
        } else {
            movieObject.moviePoster = nil
            movieObject.state = .Failed
        }
    }
}

