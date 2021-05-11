//
//  MovieDetailViewModel.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import RxSwift

enum TVShowDetailViewState {
    case initial
    case loading
    case dataLoaded
    case filtered
    case error(Error)
}

class MovieDetailViewModel {
    
    let movie: Movie
    var seasons: [Season] = []
    var episodes: [Episode] = []
    var seasonEpisodes: [Episode] = []
    let networkService = MovieDetailNetworkService()
    var viewState: BehaviorSubject<TVShowDetailViewState> = BehaviorSubject(value: .initial)
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    
    func viewWillAppear() {
        loadSeasons()
    }
    
    func loadSeasons() {
        viewState.onNext(.loading)
        networkService.loadSeasons(movieID: movie.id, onSuccess: { (seasons) in
            self.seasons = seasons
            self.viewState.onNext(.dataLoaded)
            if let firstSeason = seasons.first {
                self.loadEpisodes(season: firstSeason.id)
            }
        }, onFailure: { (error) in
            self.viewState.onNext(.error(error))
        })
    }
    
    func loadEpisodes(season: Int) {
        viewState.onNext(.loading)
        networkService.loadEpisodes(movieID: season, onSuccess: { (episodes) in
            self.seasonEpisodes = episodes
            self.viewState.onNext(.filtered)
        }, onFailure: { (error) in
            self.viewState.onNext(.error(error))
        })
    }
}
