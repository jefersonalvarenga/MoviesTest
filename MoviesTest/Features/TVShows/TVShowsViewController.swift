//
//  HomeViewController.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol ViewCodeProtocol {
    func viewCodeSetup()
    func viewAddElements()
    func viewConstraintElements()
}

extension ViewCodeProtocol {
    func viewCodeSetup() {
        viewAddElements()
        viewConstraintElements()
    }
}

class TVShowsViewController: UIViewController {
    
    struct Constant {
        static let title = "TV Shows"
        static let tblReuseIdentifier = "cellIdentifier"
        static let searchBarPlaceholder = "Search TV show"
        static let alertTitle = "Something went wrong"
        static let alertMessage = "Please try again later"
    }
    
    let disposeBag = DisposeBag()
    
    lazy var tblMovies: UITableView = {
        let tbl = UITableView()
        tbl.dataSource = self
        tbl.delegate = self
        tbl.prefetchDataSource = self
        tbl.register(TVShowsTableViewCell.self, forCellReuseIdentifier: Constant.tblReuseIdentifier)
        tbl.backgroundColor = .black
        tbl.tableFooterView?.isHidden = true
        tbl.tableHeaderView?.isHidden = true
        return tbl
    }()
    
    lazy var searchBar: UISearchController = {
        let sBar = UISearchController(searchResultsController: nil)
        sBar.searchBar.barStyle = .black
        sBar.obscuresBackgroundDuringPresentation = false
        sBar.searchBar.placeholder = Constant.searchBarPlaceholder
        return sBar
    }()
    
    lazy var loadingView: LoadingView = {
        return LoadingView()
    }()
    
    let viewModel = TVShowsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        title = Constant.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        viewCodeSetup()
        observerSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func observerSetup() {
        viewModel.viewState
            .asObserver()
            .skip(1)
            .subscribe(onNext: { (homeViewState) in
            switch homeViewState {
                case .initial:
                    self.initialState()
                case .loading:
                    self.loadingState()
                case .dataLoaded:
                    self.dataLoadedState()
                case .newDataLoaded(let newIndexPathsToReload):
                    self.newDataLoadedState(newIndexPathsToReload: newIndexPathsToReload)
                case .error(let error):
                    self.errorState(error: error)
            }
            
        }).disposed(by: disposeBag)
        
        searchBar.searchBar.rx.text
            .orEmpty
            .asObservable()
            .skip(1)
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.search(term: text)
        }).disposed(by: disposeBag)
    }
}

extension TVShowsViewController {
    
    func initialState() {
        tblMovies.isHidden = true
        searchBar.searchBar.isUserInteractionEnabled = false
    }
    
    func loadingState() {
        loadingView.startAnimating()
    }
    
    func dataLoadedState() {
        searchBar.searchBar.isUserInteractionEnabled = true
        loadingView.stopAnimating()
        tblMovies.reloadData()
    }
    
    func newDataLoadedState(newIndexPathsToReload: [IndexPath]) {
        loadingView.stopAnimating()
        tblMovies.insertRows(at: newIndexPathsToReload, with: .automatic)
    }
    
    func errorState(error: Error) {
        showAlert(title: Constant.alertTitle, message: Constant.alertMessage)
    }
}

extension TVShowsViewController: ViewCodeProtocol {
    
    func viewAddElements() {
        view.addSubview(tblMovies)
        view.addSubview(loadingView)
        navigationItem.searchController = searchBar
    }
    
    func viewConstraintElements() {
        
        tblMovies.snp.makeConstraints { (mkr) in
            mkr.top.equalToSuperview().offset(view.safeAreaInsets.top)
            mkr.left.right.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { (mkr) in
            mkr.edges.equalToSuperview()
        }
    }
}

extension TVShowsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.tblReuseIdentifier, for: indexPath) as? TVShowsTableViewCell else {
            return TVShowsTableViewCell()
        }
        cell.selectionStyle = .none
        let movie = viewModel.source[indexPath.row]
        cell.loadPoster(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.source[indexPath.row]
        navigationController?.pushViewController(TVShowDetailViewController(movie: movie), animated: true)
    }
}

extension TVShowsViewController: UITableViewDataSourcePrefetching {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row == viewModel.source.count-1
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.loadMovies()
        }
    }
}
