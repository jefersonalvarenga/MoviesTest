//
//  APIKey.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

struct APIKey {
    static let baseURL = "http://api.tvmaze.com/%@"
    static let shows = "shows?page/%d"
    static let search = "search/shows?q=%@"
    static let season = "shows/%d/seasons"
    static let epidodes = "seasons/%d/episodes"
}
