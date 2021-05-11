//
//  MovieDetailViewController.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import UIKit
import RxSwift

class MovieDetailViewController: UIViewController {
    
    struct Constant {
        static let space = 20
        static let nodeSpace = 3
        static let clvSpace = 10
        static let summary = "Summary"
        static let genres = "Genres"
        static let seasonEpisodes = "Season and episodes"
        static let timeAirs = "Time airs"
        static let forCellWithReuseIdentifier = "Cell"
        static let title = "Movie Details"
    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    lazy var stackView: UIView = {
        let stack = UIView()
        stack.backgroundColor = .black
        return stack
    }()
    
    lazy var imgPoster: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        if let posterPath = viewModel.movie.image,
            let original = posterPath.original,
            let medium = posterPath.medium,
            let url = URL(string: original) {
            img.af.setImage(withURL: url, cacheKey: original, imageTransition: UIImageView.ImageTransition.crossDissolve(0.5))
        }
        return img
    }()
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 25)
        lbl.text = viewModel.movie.name
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var lblSummary: UILabel = {
        let lbl = UILabel()
        lbl.text = Constant.summary
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var lblMovieSummary: UITextView = {
        let lbl = UITextView()
        lbl.attributedText = viewModel.movie.summary?.htmlToAttributedString
        lbl.textColor = .white
        lbl.backgroundColor = .clear
        lbl.font = .systemFont(ofSize: 18)
        lbl.textContainerInset = .zero
        lbl.textContainer.lineFragmentPadding = 0
        return lbl
    }()
    
    lazy var lblTimes: UILabel = {
        let lbl = UILabel()
        lbl.text = "\(Constant.timeAirs) \(viewModel.movie.schedule.time)"
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var clvDates: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 100, height: 30)
        layout.scrollDirection = .horizontal
        
        let clv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        clv.register(TVShowDayCollectionViewCell.self, forCellWithReuseIdentifier: Constant.forCellWithReuseIdentifier)
        
        clv.backgroundColor = .clear
        
        clv.dataSource = self
        clv.delegate = self
        
        return clv
    }()
    
    lazy var lblSeasonEpisodes: UILabel = {
        let lbl = UILabel()
        lbl.text = Constant.seasonEpisodes
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var clvSeasons: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 100, height: 30)
        layout.scrollDirection = .horizontal
        
        let clv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        clv.register(TVShowDayCollectionViewCell.self, forCellWithReuseIdentifier: Constant.forCellWithReuseIdentifier)
        
        clv.backgroundColor = .clear
        
        clv.dataSource = self
        clv.delegate = self
        
        return clv
    }()
    
    lazy var clvEpisodes: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 200, height: 30)
        layout.scrollDirection = .horizontal
        
        let clv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        clv.register(TVShowDayCollectionViewCell.self, forCellWithReuseIdentifier: Constant.forCellWithReuseIdentifier)
        
        clv.backgroundColor = .clear
        
        clv.dataSource = self
        clv.delegate = self
        
        return clv
    }()
    
    lazy var lblGenres: UILabel = {
        let lbl = UILabel()
        lbl.text = Constant.genres
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var lblMovieGenres: UILabel = {
        let lbl = UILabel()
        lbl.text = viewModel.movie.genres.joined(separator: ", ")
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var loadingView: LoadingView = {
        return LoadingView()
    }()
    
    let viewModel: MovieDetailViewModel
    let disposeBag = DisposeBag()
    
    init(movie: Movie) {
        viewModel = MovieDetailViewModel(movie: movie)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = Constant.title
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        viewCodeSetup()
        scrollView.contentSize.height = 1000
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
            .subscribe(onNext: { (viewState) in
            switch viewState {
                case .initial:
                    self.initialState()
                case .loading:
                    self.loadingState()
                case .dataLoaded:
                    self.dataLoadedState()
                case .filtered:
                    self.dataFiltered()
                case .error(let error):
                    self.errorState(error: error)
            }
            
        }).disposed(by: disposeBag)
    }
    
    func initialState() {
        
    }
    
    func loadingState() {
        loadingView.startAnimating()
    }
    
    func dataLoadedState() {
        loadingView.stopAnimating()
        clvSeasons.reloadData()
    }
    
    func dataFiltered() {
        loadingView.stopAnimating()
        clvEpisodes.reloadData()
        clvEpisodes.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
    }
    
    func errorState(error: Error) {
        loadingView.stopAnimating()
        print(error)
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clvDates {
            return viewModel.movie.schedule.days.count
        } else if collectionView == clvSeasons {
            return viewModel.seasons.count
        } else if collectionView == clvEpisodes {
            return viewModel.seasonEpisodes.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? TVShowDayCollectionViewCell else {
            return TVShowDayCollectionViewCell()
        }
        if collectionView == clvDates {
            cell.lblDay.text = viewModel.movie.schedule.days[indexPath.row]
        } else if collectionView == clvSeasons {
            let season = viewModel.seasons[indexPath.row]
            if let number =  season.number {
                cell.lblDay.text = "Season \(number.description)"
            } else {
                cell.lblDay.text = "Season \(indexPath.row.description)"
            }
        } else if collectionView == clvEpisodes {
            cell.lblDay.text = viewModel.seasonEpisodes[indexPath.row].name
        }
        return cell
    }
}

extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == clvSeasons {
            let season = viewModel.seasons[indexPath.row]
            viewModel.loadEpisodes(season: season.id)
        } else if collectionView == clvEpisodes {
            
        }
    }
}

extension MovieDetailViewController: ViewCodeProtocol {
    
    func viewAddElements() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addSubview(imgPoster)
        stackView.addSubview(lblTitle)
        stackView.addSubview(lblTimes)
        stackView.addSubview(clvDates)
        stackView.addSubview(lblGenres)
        stackView.addSubview(lblMovieGenres)
        stackView.addSubview(lblSummary)
        stackView.addSubview(lblMovieSummary)
        stackView.addSubview(lblSeasonEpisodes)
        stackView.addSubview(clvSeasons)
        stackView.addSubview(clvEpisodes)
        view.addSubview(loadingView)
    }
    
    func viewConstraintElements() {
        
        scrollView.snp.makeConstraints { (mkr) in
            mkr.top.left.right.equalToSuperview()
            mkr.bottom.equalTo(view.layoutMarginsGuide)
        }
        
        stackView.snp.makeConstraints { (mkr) in
            mkr.left.right.equalTo(view)
            mkr.height.equalTo(2000)
        }
        
        imgPoster.snp.makeConstraints { (mkr) in
            mkr.left.right.equalToSuperview()
            mkr.height.equalTo(500)
        }
        
        lblTitle.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(imgPoster.snp.bottom).offset(Constant.space)
            mkr.left.right.equalToSuperview().inset(10)
        }
        
        lblTimes.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(lblTitle.snp.bottom).offset(Constant.space)
            mkr.left.right.equalTo(lblTitle)
        }
        
        clvDates.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(lblTimes.snp.bottom).offset(Constant.nodeSpace)
            mkr.left.right.equalTo(lblTitle)
            mkr.height.equalTo(30)
        }
        
        lblGenres.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(clvDates.snp.bottom).offset(Constant.space)
            mkr.left.right.equalToSuperview().inset(10)
        }
        
        lblMovieGenres.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(lblGenres.snp.bottom).offset(Constant.nodeSpace)
            mkr.left.right.equalTo(lblTitle)
        }
        
        lblSummary.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(lblMovieGenres.snp.bottom).offset(Constant.space)
            mkr.left.right.equalTo(lblTitle)
        }
        
        lblMovieSummary.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(lblSummary.snp.bottom).offset(Constant.nodeSpace)
            mkr.left.right.equalTo(lblTitle)
            mkr.height.equalTo(130)
        }
        
        lblSeasonEpisodes.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(lblMovieSummary.snp.bottom).offset(Constant.space)
            mkr.left.right.equalTo(lblTitle)
        }
        
        clvSeasons.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(lblSeasonEpisodes.snp.bottom).offset(Constant.clvSpace)
            mkr.left.right.equalTo(lblTitle)
            mkr.height.equalTo(30)
        }
        
        clvEpisodes.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(clvSeasons.snp.bottom).offset(Constant.clvSpace)
            mkr.left.right.equalTo(lblTitle)
            mkr.height.equalTo(30)
        }
        
        loadingView.snp.makeConstraints { (mkr) in
            mkr.edges.equalToSuperview()
        }
    }
}
