//
//  EpisodeDetailViewController.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    
    struct Constant {
        static let space = 20
        static let nodeSpace = 3
        static let summary = "Summary"
        static let title = "Episode Details"
        static let viewHeight: CGFloat = 800.0
        static let season = "Season"
        static let episode = "episode"
        static let notAvailable = "Not available"
        static let alertTitle = "Something went wrong"
        static let alertMessage = "Please try again later"
        static let imagePlaceholder = "imagePlaceholder"
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
        if let posterPath = viewModel.episode.image,
            let original = posterPath.original,
            let url = URL(string: original) {
            img.af.setImage(withURL: url, cacheKey: original, imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), completion: { (image) in
                if let error = image.error {
                    img.image = UIImage(named: Constant.imagePlaceholder)
                }
                self.loadingView.stopAnimating()
            })
        } else {
            loadingView.stopAnimating()
            img.image = UIImage(named: Constant.imagePlaceholder)
        }
        return img
    }()
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 25)
        lbl.text = viewModel.episode.name
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var lblSummary: UILabel = {
        let lbl = UILabel()
        lbl.text = Constant.summary
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var lblSeasonNumber: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.text = "\(Constant.season) \(viewModel.season.number?.description ?? Constant.notAvailable), \(Constant.episode) \(viewModel.episode.number?.description ?? Constant.notAvailable)"
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var lblMovieSummary: UITextView = {
        let lbl = UITextView()
        lbl.attributedText = viewModel.episode.summary?.htmlToAttributedString
        lbl.textColor = .white
        lbl.backgroundColor = .clear
        lbl.font = .systemFont(ofSize: 18)
        lbl.textContainerInset = .zero
        lbl.textContainer.lineFragmentPadding = 0
        return lbl
    }()
    
    lazy var loadingView: LoadingView = {
        return LoadingView()
    }()
    
    let viewModel: EpisodeDetailViewModel
    
    init(episode: Episode, season: Season) {
        viewModel = EpisodeDetailViewModel(episode: episode, season: season)
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension EpisodeDetailViewController: ViewCodeProtocol {
    
    func viewAddElements() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(imgPoster)
        containerView.addSubview(lblTitle)
        containerView.addSubview(lblSeasonNumber)
        containerView.addSubview(lblSummary)
        containerView.addSubview(lblMovieSummary)
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
        
        lblSeasonNumber.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(lblTitle.snp.bottom).offset(Constant.space)
            mkr.left.right.equalTo(lblTitle)
        }
        
        lblSummary.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(lblSeasonNumber.snp.bottom).offset(Constant.space)
            mkr.left.right.equalTo(lblTitle)
        }
        
        lblMovieSummary.snp.makeConstraints { (mkr) in
            mkr.top.equalTo(lblSummary.snp.bottom).offset(Constant.nodeSpace)
            mkr.left.right.equalTo(lblTitle)
            mkr.height.equalTo(150)
        }
        
        loadingView.snp.makeConstraints { (mkr) in
            mkr.edges.equalToSuperview()
        }
    }
}
