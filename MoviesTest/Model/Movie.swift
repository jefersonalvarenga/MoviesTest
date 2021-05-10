//
//  Movie.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import Foundation

struct Season: Codable {
    let id: Int
    let number: Int?
}

struct Episode: Codable {
    let id: Int
    let number: Int?
    let name: String
    let season: Int
    let summary: String?
    let image: MovieImage?
}

struct MovieSearch: Codable {
    let score: Double
    let show: Movie
    
}

struct Dates: Codable {
    let time: String
    let days: [String]
}

struct Movie: Codable {
    let id: Int
    let name: String
    let image: MovieImage?
    let summary: String?
    let score: Double?
    let schedule: Dates
    let genres: [String]
}

struct MovieImage: Codable {
    let medium: String?
    let original: String?
}
