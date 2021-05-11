//
//  TVShowDetailViewController.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import UIKit
import RxSwift

class TVShowDetailViewController: UIViewController {
    
    struct Constant {
        static let space = 20
        static let nodeSpace = 3
        static let clvSpace = 10
        static let viewHeight: CGFloat = 1000.0
        static let summary = "Summary"
        static let genres = "Genres"
        static let seasonEpisodes = "Season and episodes"
        static let timeAirs = "Time airs"
        static let forCellWithReuseIdentifier = "Cell"
        static let title = "TV Show Details"
        static let season = "Season"
        static let alertTitle = "Something went wrong"
        static let alertMessage = "Please try again later"
    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    lazy var containerView: UIView = {
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
            let url = URL(string: original) {
            img.af.setImage(withURL: url, cacheKey: original, imageTransition: UIImageView.ImageTransition.crossDissolve(0.5)) { (image) in
                if let _ = image.error {
                    self.imgPoster.image = UIImage(named: "imagePlaceholder")
                }
            }
        } else {
            img.image = UIImage(named: "imagePlaceholder")
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
    
    lazy var txtMovieSummary: UITextView = {
        let txt = UITextView()
        txt.attributedText = viewModel.movie.summary?.htmlToAttributedString
        txt.textColor = .white
        txt.backgroundColor = .clear
        txt.font = .systemFont(ofSize: 18)
        txt.textContainerInset = .zero
        txt.textContainer.lineFragmentPadding = 0
        return txt
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
        clv.register(TVShowDetailCollectionViewCell.self, forCellWithReuseIdentifier: Constant.forCellWithReuseIdentifier)
        
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
        clv.register(TVShowDetailCollectionViewCell.self, forCellWithReuseIdentifier: Constant.forCellWithReuseIdentifier)
        
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
        clv.register(TVShowDetailCollectionViewCell.self, forCellWithReuseIdentifier: Constant.forCellWithReuseIdentifier)
        
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
    
    let viewModel: TVShowDetailViewModel
    let disposeBag = DisposeBag()
    
    init(movie: Movie) {
        viewModel = TVShowDetailViewModel(movie: movie)
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
        scrollView.contentSize.height = Constant.viewHeight
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
        showAlert(title: Constant.alertTitle, message: Constant.alertMessage)
    }
    
    func showEpisodeDetail(episode: Episode, season: Season) {
        navigationController?.pushViewController(EpisodeDetailViewController(episode: episode, season: season), animated: true)
    }
}

extension TVShowDetailViewController: UICollectionViewDataSource {
    
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.forCellWithReuseIdentifier, for: indexPath) as? TVShowDetailCollectionViewCell else {
            return TVShowDetailCollectionViewCell()
        }
        if collectionView == clvDates {
            cell.setData(data: viewModel.movie.schedule.days[indexPath.row], color: .darkGray)
        } else if collectionView == clvSeasons {
            let season = viewModel.seasons[indexPath.row]
            if let number =  season.number {
                cell.setData(data: "\(Constant.season) \(number.description)", color: .white)
            } else {
                cell.setData(data: "\(Constant.season) \(indexPath.row.description)", color: .white)
            }
        } else if collectionView == clvEpisodes {
            cell.setData(data: viewModel.seasonEpisodes[indexPath.row].name, color: .white)
        }
        return cell
    }
}

extension TVShowDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == clvSeasons {
            let season = viewModel.seasons[indexPath.row]
            viewModel.loadEpisodes(season: season.id)
        } else if collectionView == clvEpisodes {
            if let index = clvSeasons.indexPathsForSelectedItems?.first {
                let season = viewModel.seasons[index.row]
                let episode = viewModel.seasonEpisodes[indexPath.row]
                showEpisodeDetail(episode: episode, season: season)
            } else {
                let season = viewModel.seasons[0]
                let episode = viewModel.seasonEpisodes[indexPath.row]
                showEpisodeDetail(episode: episode, season: season)
            }
        }
    }
}

extension TVShowDetailViewController: ViewCodeProtocol {
    
    func viewAddElements() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(imgPoster)
        containerView.addSubview(lblTitle)
        containerView.addSubview(lblTimes)
        containerView.addSubview(clvDates)
        containerView.addSubview(lblGenres)
        containerView.addSubview(lblMovieGenres)
        containerView.addSubview(lblSummary)
        containerView.addSubview(txtMovieSummary)
        containerView.addSubview(lblSeasonEpisodes)
        containerView.addSubview(clvSeasons)
        containerView.addSubview(clvEpisodes)
        view.addSubview(loadingView)
    }
    
    func viewConstraintElements() {
        
        scrollView.snp.makeConstraints { (mkr) in
            mkr.top.left.right.equalToSuperview()
            mkr.bottom.equalTo(view.layoutMarginsGuide)
        }
        
        containerView.snp.makeConstraints { (mkr) in
            mkr.left.right.equalTo(view)
            mkr.height.equalTo(Constant.viewHeight)
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
        
        txtMovieSummary.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(lblSummary.snp.bottom).offset(Constant.nodeSpace)
            mkr.left.right.equalTo(lblTitle)
            mkr.height.equalTo(130)
        }
        
        lblSeasonEpisodes.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(txtMovieSummary.snp.bottom).offset(Constant.space)
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
