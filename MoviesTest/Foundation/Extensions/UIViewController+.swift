//
//  UIViewController+.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 10/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?,
                   message: String,
                   preferredStyle: UIAlertController.Style = .alert,
                   actions: [UIAlertAction]? = nil) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if let unwrapped = actions {
            for action in unwrapped {
                alertView.addAction(action)
            }
        } else {
            let basicAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertView.addAction(basicAction)
        }
        present(alertView, animated: true)
    }
}
