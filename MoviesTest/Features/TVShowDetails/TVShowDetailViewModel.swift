//
//  TVShowDetailViewModel.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import RxSwift

enum TVShowDetailViewState: Equatable {
    static func == (lhs: TVShowDetailViewState, rhs: TVShowDetailViewState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        default:
            return false
        }
    }
    
    case initial
    case loading
    case dataLoaded
    case filtered
    case error(Error)
}

class TVShowDetailViewModel {
    
    let movie: Movie
    var seasons: [Season] = []
    var seasonEpisodes: [Episode] = []
    let networkService = TVShowDetailNetworkService()
    var viewState: BehaviorSubject<TVShowDetailViewState> = BehaviorSubject(value: .initial)
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func viewWillAppear() {
        if let state = try? viewState.value(), state == .initial {
            loadSeasons()
        }
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
