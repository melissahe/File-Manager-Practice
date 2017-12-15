//
//  Favorite.swift
//  File Manager Practice
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Melissa He @ C4Q. All rights reserved.
//

import UIKit

struct Favorite: Codable {
    let collectionName: String?
    let collectionId: Int?
    let trackId: Int
    let trackName: String?
    let longDescription: String?
    
    var image: UIImage? {
        set{}
        
        //computed property to return image from documents
        get {
            let imageURL = PersistentStoreManager.manager.dataFilePath(withPathName: "\(trackId)")
            let docImage = UIImage(contentsOfFile: imageURL.path) //the actual image
            return docImage
        }
    }
    
}
