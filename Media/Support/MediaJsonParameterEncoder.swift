//
//  MediaJsonParameterEncoder.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import Alamofire

class MediaJSONParameterEncoder: ParameterEncoder {
    
    static var `default`: MediaJSONParameterEncoder {
        return MediaJSONParameterEncoder()
    }
    let encoder: JSONEncoder
    
    init(encoder: JSONEncoder = JSONEncoder()) {
        self.encoder = encoder
    }
    
    func encode<Parameters>(_ parameters: Parameters?, into request: URLRequest) throws -> URLRequest where Parameters : Encodable {
        guard let parameters = parameters else { return request }
        
        var request = request
        if case .get? = request.method, let queryParams = parameters as? [String: Any] {
            guard let urlStr = request.url?.absoluteString else {
                assertionFailure()
                return request
            }
            var urlComponents = URLComponents(string: urlStr)
            urlComponents?.queryItems = queryParams.map({ (key, value) -> URLQueryItem in
                URLQueryItem(name: key, value: value as? String)
            })
            do {
                request.url = try urlComponents?.asURL()
            } catch {
                throw AFError.parameterEncodingFailed(reason: AFError.ParameterEncodingFailureReason.jsonEncodingFailed(error: error))
            }
 
        } else {
            do {
                let data = try encoder.encode(parameters)
                request.httpBody = data
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
            
        }
        
        if request.headers["Content-Type"] == nil {
            request.headers.update(.contentType("application/json"))
        }
        return request
        
    }
    
    
}
