//
//  HomeInteractor.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import Foundation
import RxSwift


enum TVShowsViewState: Equatable {
    case initial
    case loading
    case dataLoaded
    case newDataLoaded([IndexPath])
    case error(Error)
    
    static func == (lhs: TVShowsViewState, rhs: TVShowsViewState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        default:
            return false
        }
    }
}

class TVShowsViewModel {
    
    var viewState: BehaviorSubject<TVShowsViewState> = BehaviorSubject(value: .initial)
    var movies: [Movie] = []
    var searchMovies: [Movie] = []
    private var backupMovies: [Movie] = []
    private var nextPage = 0
    private var isFetchInProgress = false
    private var isSearch = false
    
    var source: [Movie] {
        if isSearch {
            return searchMovies
        } else {
            return movies
        }
    }
    
    func viewWillAppear() {
        if let state = try? viewState.value(), state == .initial {
            loadMovies()
        }
    }
    
    func loadMovies() {
        guard !isFetchInProgress && !isSearch else {
          return
        }
        viewState.onNext(.loading)
        isFetchInProgress = true
        let networkService = TVShowsNetwortService()
        networkService.loadMovies(page: nextPage, onSuccess: { (movies) in
            self.isFetchInProgress = false
            self.nextPage += 1
            if self.movies.count == 0 {
                self.movies.append(contentsOf: movies)
                self.viewState.onNext(.dataLoaded)
            } else {
                self.movies.append(contentsOf: movies)
                let indexPathsToReload = self.getNextIndexPaths(from: movies)
                self.viewState.onNext(.newDataLoaded(indexPathsToReload))
            }
        }, onFailure:  { (error) in
            self.isFetchInProgress = false
            self.viewState.onNext(.error(error))
        })
    }
    
    func search(term: String) {
        guard !isFetchInProgress else {
          return
        }
        if term.isEmpty {
            isSearch = false
            viewState.onNext(.dataLoaded)
            return
        }
        isSearch = true
        viewState.onNext(.loading)
        isFetchInProgress = true
        let networkService = TVShowsNetwortService()
        networkService.searchMovies(term: term, onSuccess: { (movies) in
            self.isFetchInProgress = false
            self.searchMovies = movies.map({ (item) -> Movie in
                self.isFetchInProgress = false
                return Movie(id: item.show.id, name:
                                item.show.name,
                                image: item.show.image,
                                summary: item.show.summary,
                                score: item.score,
                                schedule: item.show.schedule, genres: item.show.genres)
            })
            self.viewState.onNext(.dataLoaded)
        }, onFailure: {(error) in
            self.isFetchInProgress = false
            self.viewState.onNext(.error(error))
        })
    }
    
    func getNextIndexPaths(from tvShows: [Movie]) -> [IndexPath] {
      let startIndex = movies.count - tvShows.count
      let endIndex = startIndex + tvShows.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func filter(term: String) {
        if !isSearch {
            isSearch = true
            backupMovies = movies
        } else {
            if term.isEmpty {
                isSearch = false
                movies = backupMovies
            } else {
                movies = movies.filter{$0.name.localizedCaseInsensitiveContains(term)}
            }
            viewState.onNext(.dataLoaded)
        }
    }
}
