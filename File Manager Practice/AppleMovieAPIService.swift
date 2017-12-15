//
//  AppleMovieAPIService.swift
//  File Manager Practice
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Melissa He @ C4Q. All rights reserved.
//

import Foundation

let searchURL = "https://itunes.apple.com/search?media=movie&term="
//another singleton
let session = URLSession.shared

class AppleMovieAPIService {
    
    private init() {}
    static let shared = AppleMovieAPIService()
    
    func searchMovie(keyword: String, completion: @escaping (Error?, [Movie]?) -> Void) {
        
        session.dataTask(with: URL(string: "\(searchURL)\(keyword)")!) { (data, response, error) in
            
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode(MovieResults.self, from: data)
                    completion(nil, movies.results)
                } catch let error {
                    print("Decoding Error: \(error.localizedDescription)")
                    completion(error, nil)
                }
            }
            
        }.resume()
        
    }
}
