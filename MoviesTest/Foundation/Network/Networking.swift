//
//  Networking.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 08/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

public enum NetworkError: Error {
    case response(statusCode: Int?, message: String?, error: Error?)
    case parse
    case unknown
}

public typealias onFailure = (NetworkError) -> Void

class Networking: NSObject {
    
    let manager = Session()
    
    public func request<T: Codable>(_
                                        urlString: String,
                                        body: Dictionary<String, Any>? = nil,
                                        method: String = "GET",
                                        headers: [String: String]? = nil,
                                        onSuccess: @escaping (T) -> Void,
                                        onFailure: @escaping onFailure) {
        
        guard let url = URL(string: urlString) else {
            onFailure(NetworkError.unknown)
            return
        }
        
        //Method
        let httpMethod = HTTPMethod(rawValue: method)
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        //Body
        if let params = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        
        //Headers
        if let unwrapedHeaders = headers {
            for header in unwrapedHeaders {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        } else {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        AF.request(request).validate().responseDecodable(of: T.self, decoder: decoder) { (response) in
            switch response.result {
            case .success(let result):
                onSuccess(result)
            case .failure(let error):
                onFailure(NetworkError.response(statusCode: response.response?.statusCode, message: response.description, error: error))
            }
        }
    }
    
    public func request<T: Codable>(_
                                     urlString: String,
                                     body: Dictionary<String, Any>? = nil,
                                     method: String = "GET",
                                     headers: [String: String]? = nil,
                                     onSuccess: @escaping ([T]) -> Void,
                                     onFailure: @escaping onFailure) {
        
        guard let url = URL(string: urlString) else {
            onFailure(NetworkError.unknown)
            return
        }
        
        //Method
        let httpMethod = HTTPMethod(rawValue: method)
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        //Body
        if let params = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        
        //Headers
        if let unwrapedHeaders = headers {
            for header in unwrapedHeaders {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        } else {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        AF.request(request).validate().responseDecodable(of: [T].self, decoder: decoder) { (response) in
            switch response.result {
            case .success(let result):
                onSuccess(result)
            case .failure(let error):
                onFailure(NetworkError.response(statusCode: response.response?.statusCode, message: response.description, error: error))
            }
        }
    }
}
