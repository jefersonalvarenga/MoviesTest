//
//  Movie.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let name: String
    let image: MovieImage?
    let summary: String?
    let score: Double?
    let schedule: Dates
    let genres: [String]
}
