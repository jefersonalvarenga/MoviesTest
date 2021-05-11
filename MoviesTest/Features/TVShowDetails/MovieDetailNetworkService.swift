//
//  MovieDetailNetworkService.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 10/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

class MovieDetailNetworkService {
    
    func loadSeasons(movieID: Int, onSuccess: @escaping ([Season]) -> Void, onFailure: @escaping onFailure) {
        let url = String(format:APIKey.baseURL, String(format: APIKey.season, movieID))
        
        callNetwork(url: url, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func loadEpisodes(movieID: Int, onSuccess: @escaping ([Episode]) -> Void, onFailure: @escaping onFailure) {
        let url = String(format:APIKey.baseURL, String(format: APIKey.epidodes, movieID))
        
        callNetwork(url: url, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func callNetwork<T: Codable>(url: String, onSuccess: @escaping ([T]) -> Void, onFailure: @escaping onFailure) {
        
        let network = Networking()
        network.request(url, onSuccess: { (movies) in
            onSuccess(movies)
        }, onFailure:  { (error) in
            onFailure(error)
        })
    }
}
