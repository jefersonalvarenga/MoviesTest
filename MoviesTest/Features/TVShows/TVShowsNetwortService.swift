//
//  TVShows.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

class TVShowsNetwortService {
    
    private let network: Networking
    
    init(network: Networking = Networking()) {
        self.network = network
    }
    
    func loadMovies(page: Int, onSuccess: @escaping ([Movie]) -> Void, onFailure: @escaping onFailure) {
        let url = String(format:APIKey.baseURL, String(format: APIKey.shows, page))
        callNetwork(url: url, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func searchMovies(term: String, onSuccess: @escaping ([MovieSearch]) -> Void, onFailure: @escaping onFailure) {
        guard let enconded = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        let url = String(format:APIKey.baseURL, String(format: APIKey.search, enconded))
        callNetwork(url: url, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func callNetwork<T: Codable>(url: String, onSuccess: @escaping ([T]) -> Void, onFailure: @escaping onFailure) {
        network.request(url, onSuccess: { (movies) in
            onSuccess(movies)
        }, onFailure:  { (error) in
            onFailure(error)
        })
    }
}
