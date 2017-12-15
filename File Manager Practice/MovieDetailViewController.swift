//
//  MovieDetailViewController.swift
//  File Manager Practice
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Melissa He @ C4Q. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var favoriteImageBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieDescriptionTextView: UITextView!
    
    var movie: Movie!
    var imageView: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView(movie: movie)
    }
    
    func configureView(movie: Movie) {
        
        //title
        titleLabel.text = movie.trackName ?? ""
        
        //description
        movieDescriptionTextView.text = movie.longDescription ?? "No description"
        
        //process image
        movieImageView.image = imageView
        
        let favoritesList = PersistentStoreManager.manager.getFavorites()
        
        if favoritesList.contains(where: {$0.trackId == movie.trackId}) {
            favoriteImageBarButtonItem.image = #imageLiteral(resourceName: "favorite-filled-32")
            favoriteImageBarButtonItem.tintColor = UIColor(red: 1, green: 0.414, blue: 0.515, alpha: 1)
        }
    }
    
    @IBAction func addToFavoritesButtonPressed(_ sender: UIBarButtonItem) {
        let favoriteMovies = PersistentStoreManager.manager.getFavorites()
        
        if favoriteMovies.contains(where: {$0.trackId == movie.trackId}) {
            PersistentStoreManager.manager.deleteFavorite(movie: movie)
            favoriteImageBarButtonItem.image = #imageLiteral(resourceName: "favorite-unfilled-32")
            favoriteImageBarButtonItem.tintColor = UIColor(red: 0.674, green: 0.686, blue: 0.741, alpha: 1)
        } else {
            PersistentStoreManager.manager.addToFavorites(movie: movie, andImage: imageView)
            
            favoriteImageBarButtonItem.image = #imageLiteral(resourceName: "favorite-filled-32")
            favoriteImageBarButtonItem.tintColor = UIColor(red: 1, green: 0.414, blue: 0.515, alpha: 1)
        }
    }
    
}
