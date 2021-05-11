//
//  MoviewCollectionViewCell.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import AlamofireImage

class TVShowsTableViewCell: UITableViewCell {
        
    lazy var imgMovie: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    lazy var titleBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var actView: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView()
        act.hidesWhenStopped = true
        act.startAnimating()
        return act
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        viewCodeSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgMovie.af.cancelImageRequest()
        imgMovie.layer.removeAllAnimations()
        imgMovie.image = nil
    }
    
    func loadPoster(movie: Movie) {
        if let path = movie.image?.original,
            let url = URL(string: path) {
            lblTitle.text = movie.name
            imgMovie.af.setImage(withURL: url, cacheKey: path, imageTransition: UIImageView.ImageTransition.crossDissolve(0.5)) { (image) in
                    if let _ = image.error {
                        self.imgMovie.image = UIImage(named: "imagePlaceholder")
                    }
                    self.actView.stopAnimating()
            }
        } else {
            imgMovie.image = UIImage(named: "imagePlaceholder")
        }
    }
}

extension TVShowsTableViewCell: ViewCodeProtocol {
    
    func viewAddElements() {
        contentView.addSubview(imgMovie)
        contentView.addSubview(titleBackground)
        contentView.addSubview(lblTitle)
        contentView.addSubview(actView)
    }
    
    func viewConstraintElements() {
        
        imgMovie.snp.makeConstraints { (mkr) in
            mkr.top.left.right.equalToSuperview()
            mkr.bottom.equalTo(titleBackground.snp.top)
        }
        
        titleBackground.snp.makeConstraints { (mkr) in
            mkr.bottom.equalToSuperview().inset(20)
            mkr.width.equalToSuperview()
            mkr.height.equalTo(40)
        }
        
        lblTitle.snp.makeConstraints { (mkr) in
            mkr.left.right.equalToSuperview().inset(20)
            mkr.centerY.equalTo(titleBackground)
        }
        
        actView.snp.makeConstraints { (mkr) in
            mkr.center.equalToSuperview()
        }
    }
}
