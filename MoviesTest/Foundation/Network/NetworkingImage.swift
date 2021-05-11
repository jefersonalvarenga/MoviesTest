//
//  NetworkingImage.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class NetworkingImage {

    func request(_ url: String, onSuccess: @escaping (Image) -> Void, onFailure: @escaping onFailure) {
        AF.request(url).responseImage(imageScale: 1, inflateResponseImage: false, completionHandler: {response in
            if case .success(let image) = response.result {
                DispatchQueue.main.async {
                    onSuccess(image)
                }
            } else {
                onFailure(.response(statusCode: response.response?.statusCode, message: response.error?.localizedDescription, error: response.error))
            }
        })
    }
}
