//
//  PersistentStoreManager.swift
//  File Manager Practice
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Melissa He @ C4Q. All rights reserved.
//

import UIKit

class PersistentStoreManager {
    
    static let kPath = "Favorites.plist"
    
    //singleton manager
    private init() {}
    static let manager = PersistentStoreManager()
    
    
    private var favorites = [Favorite]() {
        didSet {
            //saving to the apps sandbox (plist in documents folder)
            saveFavorites()
        }
    }
    
    //returns documents directory path for app sandbox
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    //returns the path for the supplied name from the documents directory
    func dataFilePath(withPathName path: String) -> URL {
        return documentsDirectory().appendingPathComponent(path)
    }
    
    //save
    func saveFavorites() {
        let encoder = PropertyListEncoder()
        
        do {
            //turn the thing you want to save into data
            let data = try encoder.encode(favorites)
            //write that data to the specified path
            try data.write(to: dataFilePath(withPathName: PersistentStoreManager.kPath), options: .atomic)
        } catch let error {
            print("Encoding error: \(error)")
        }
        
        print("============================")
        print(documentsDirectory())
        print("============================\n")
    }
    
    //load
    func loadFavorites() {
        //the location we are using to load from
        let path = dataFilePath(withPathName: PersistentStoreManager.kPath)
        let decoder = PropertyListDecoder()
        
        do {
            let data = try Data.init(contentsOf: path)
            favorites = try decoder.decode([Favorite].self, from: data)
        } catch let error {
            print("Decoding error: \(error.localizedDescription)")
        }
    }
    
    //does two things:
        //1. store image in documents folder
        //2. appends favorite item to array
    //adds Image to favorites
    func addToFavorites(movie: Movie, andImage image: UIImage) {
        //check if the favorites list has the current movie already (will return nil if not)
            //checking for uniqueness
        let indexExist = favorites.index {$0.trackId == movie.trackId}
        
        //if the favorite has it already, it returns
        if indexExist != nil {
            print("FAVORITE EXIST!")
            return
        }
        
        //generates data for a image, data is for a png format
        //packing data from image
        guard let imageData = UIImagePNGRepresentation(image) else {
            return
        }
        
        //writing and savings to documents folder
        
        //1) save image from favorite photo
        let imageURL = PersistentStoreManager.manager.dataFilePath(withPathName: "\(movie.trackId)")
        
        do {
            try imageData.write(to: imageURL)
        } catch let error {
            print("Image saving error: \(error.localizedDescription)")
        }
        
        //2) save favorite object
        let newFavorite = Favorite(collectionName: movie.collectionName, collectionId: movie.collectionId, trackId: movie.trackId, trackName: movie.trackName, longDescription: movie.longDescription)
        
        favorites.append(newFavorite)
        
    }

    //get
    func getFavorites() -> [Favorite] {
        return favorites
    }
    
    //delete
    func deleteFavorite(movie: Movie, andImage image: UIImage) {
        favorites.remove(at: favorites.index{$0.trackId == movie.trackId}!)
        //to do
    }
    
}
