//
//  Episode.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 10/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import Foundation

struct Episode: Decodable {
    let id: Int
    let number: Int?
    let name: String
    let season: Int
    let summary: String?
    let image: MovieImage?
}
