//
//  EpisodeDetailViewModel.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

class EpisodeDetailViewModel {
    
    let episode: Episode
    let season: Season
    
    init(episode: Episode, season: Season) {
        self.episode = episode
        self.season = season
    }
}
