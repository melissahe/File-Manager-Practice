//
//  ViewController.swift
//  File Manager Practice
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Melissa He @ C4Q. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController {
    
    let cellSpacing: CGFloat = UIScreen.main.bounds.width * 0.05
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieSearchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let detailVC = segue.destination as! MovieDetailViewController
            let cell = sender as! MovieCollectionViewCell
            if let indexPath = movieCollectionView.indexPath(for: cell) {
                let currentMovie = movies[indexPath.row]
                
                detailVC.movie = currentMovie
                detailVC.imageView = cell.movieImageView.image ?? #imageLiteral(resourceName: "placeholder")
            }
        }
    }
    
    func configureMovie(movie: Movie, forCell cell: MovieCollectionViewCell) {
        DispatchQueue.global().async {
            do {
                let imageData = try Data.init(contentsOf: movie.artworkUrl100)
                
                let image = UIImage(data: imageData)!
                
                DispatchQueue.main.sync {
                    cell.movieImageView.image = image
                    cell.setNeedsLayout()
                }
            } catch let error {
                print("image processing error: \(error.localizedDescription)")
                DispatchQueue.main.sync {
                    cell.movieImageView.image = #imageLiteral(resourceName: "placeholder")
                }
            }
        }
    }
    
}

extension MovieSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        
        cell.movieImageView.image = nil
        
        configureMovie(movie: movie, forCell: cell)
        
        return cell
    }
    
}

extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    
    //Your implementation of this method can return a fixed set of sizes or dynamically adjust the sizes based on the cell’s content.
    
    //set the size of the cell - should change based on whether it's horizontal scrolling or vertical scrolling
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCells: CGFloat = 2 // the number of cells you want in a screen
        let numberOfSpaces = numberOfCells + 1 //always minus one because there are n + 1 spaces around n cells (remember the insets spacings count too)
        let width = (UIScreen.main.bounds.width - (cellSpacing * numberOfSpaces)) / numberOfCells
        let height = UIScreen.main.bounds.height * 0.25
        
        return CGSize(width: width, height: height)
    }
    
    //set the insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //can be the same as the spacing
        
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    }
    
    //set the spacing between successive rows or columns of a section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return cellSpacing
    }
    
    //set the spacing between the items in a row or column
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return cellSpacing
    }
    
}

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() //to make searchBar go away
        
        guard let searchText = searchBar.text else {
            return
        }
        
        //only make call if the search bar is not empty
        if !searchText.isEmpty {
            guard let encodedKeyword = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return
            }
            
            AppleMovieAPIService.shared.searchMovie(
                keyword: encodedKeyword,
                completion: { (error, movies) in
                    if let error = error {
                        let alertController = UIAlertController(title: "Error Occurred", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else if let movies = movies {
                        self.movies = movies
                    }
            })
        }
    }
}
