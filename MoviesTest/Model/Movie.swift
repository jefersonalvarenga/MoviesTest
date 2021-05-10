//
//  Movie.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import Foundation

//{"id":1,"url":"https://www.tvmaze.com/shows/1/under-the-dome","name":"Under the Dome","type":"Scripted","language":"English","genres":["Drama","Science-Fiction","Thriller"],"status":"Ended","runtime":60,"premiered":"2013-06-24","officialSite":"http://www.cbs.com/shows/under-the-dome/","schedule":{"time":"22:00","days":["Thursday"]},"rating":{"average":6.6},"weight":96,"network":{"id":2,"name":"CBS","country":{"name":"United States","code":"US","timezone":"America/New_York"}},"webChannel":null,"dvdCountry":null,"externals":{"tvrage":25988,"thetvdb":264492,"imdb":"tt1553656"},"image":{"medium":"https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg","original":"https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"},"summary":"<p><b>Under the Dome</b> is the story of a small town that is suddenly and inexplicably sealed off from the rest of the world by an enormous transparent dome. The town's inhabitants must deal with surviving the post-apocalyptic conditions while searching for answers about the dome, where it came from and if and when it will go away.</p>","updated":1617697381,"_links":{"self":{"href":"https://api.tvmaze.com/shows/1"},"previousepisode":{"href":"https://api.tvmaze.com/episodes/185054"}}}

struct MovieSearch: Codable {
    let score: Double
    let show: Movie
    
}

struct Dates: Codable {
    let maximum: String
    let minimum: String
}

struct Movie: Codable {
    let name: String
    let image: MovieImage?
    let summary: String?
    let score: Double?
}

struct MovieImage: Codable {
    let medium: String?
    let original: String?
}
