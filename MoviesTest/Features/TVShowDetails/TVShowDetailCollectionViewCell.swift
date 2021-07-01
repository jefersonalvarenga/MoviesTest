//
//  TVShowDetailCollectionViewCell.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 10/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import UIKit

class TVShowDetailCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewCodeSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            lblData.layer.borderColor = isSelected ? UIColor.red.cgColor : traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        lblData.layer.borderColor = isSelected ? UIColor.red.cgColor : traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
    }
    
    lazy var lblData: UILabel = {
        let lbl = UILabel()
        lbl.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        lbl.layer.borderWidth = 1
        lbl.textAlignment = .center
        return lbl
    }()
    
    func setData(data: String?, color: UIColor?) {
        lblData.text = data
        //lblData.layer.borderColor = color?.cgColor
    }
}

extension TVShowDetailCollectionViewCell: ViewCodeProtocol {
    func viewAddElements() {
        contentView.addSubview(lblData)
    }
    
    func viewConstraintElements() {
        lblData.snp.makeConstraints { (mkr) in
            mkr.edges.equalToSuperview()
        }
    }
}
