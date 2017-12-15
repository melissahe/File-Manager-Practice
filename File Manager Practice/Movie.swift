//
//  Movie.swift
//  File Manager Practice
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Melissa He @ C4Q. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let artworkUrl100: URL
    let artworkUrl60: URL
    let collectionName: String?
    let collectionId: Int?
    let trackId: Int
    let longDescription: String?
}

struct MovieResults: Codable {
    let results: [Movie]
}
