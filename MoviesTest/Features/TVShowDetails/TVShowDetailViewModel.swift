//
//  TVShowDetailViewModel.swift
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
    case dataLoadedSeasons
    case error(Error)
}

class TVShowDetailViewModel {
    
    let movie: Movie
    var seasons: [Season] = []
    var seasonEpisodes: [Episode] = []
    var viewState: BehaviorSubject<TVShowDetailViewState> = BehaviorSubject(value: .initial)
    private let service: TVShowDetailNetworkService
    
    init(service: TVShowDetailNetworkService, movie: Movie) {
        self.service = service
        self.movie = movie
    }
    
    func viewWillAppear() {
        if let state = try? viewState.value() {
            switch state{
            case .initial:
                loadSeasons()
            default:
                break
            }
        }
    }
    
    func loadSeasons() {
        viewState.onNext(.loading)
        service.loadSeasons(movieID: movie.id, onSuccess: { (seasons) in
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
        service.loadEpisodes(movieID: season, onSuccess: { (episodes) in
            self.seasonEpisodes = episodes
            self.viewState.onNext(.dataLoadedSeasons)
        }, onFailure: { (error) in
            self.viewState.onNext(.error(error))
        })
    }
}
