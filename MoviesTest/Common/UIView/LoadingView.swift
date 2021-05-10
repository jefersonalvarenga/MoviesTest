//
//  LoadingView.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 10/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var isPresented = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        viewCodeSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var activeIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.color = .white
        return view
    }()
    
    func startAnimating() {
        if !isPresented {
            isUserInteractionEnabled = true
            isPresented = true
            layer.removeAllAnimations()
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: {
                self.bgView.alpha = 0.9
                self.activeIndicatorView.startAnimating()
            })
        }
    }

    func stopAnimating() {
        if isPresented {
            activeIndicatorView.stopAnimating()
            layer.removeAllAnimations()
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: {
                self.bgView.alpha = 0
            }, completion: { (bool) in
                self.isPresented = false
                self.isUserInteractionEnabled = false
            })
        }
    }
}

extension LoadingView: ViewCodeProtocol {
    func viewAddElements() {
        addSubview(bgView)
        addSubview(activeIndicatorView)
    }
    
    func viewConstraintElements() {
        
        bgView.snp.makeConstraints { (mkr) in
            mkr.edges.equalToSuperview()
        }
        
        activeIndicatorView.snp.makeConstraints { (mkr) in
            mkr.width.height.equalTo(100)
            mkr.center.equalTo(bgView)
        }
    }
}
