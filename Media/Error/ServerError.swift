//
//  ServerError.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation


enum NetworkError: LocalizedError {
    case internetConnection
    case serverResponse(String)
    case clientError(ClientErrorStatus)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .internetConnection:
            return "Internet connection"
        case .serverResponse(let message):
            return "server response \(message)"
        case .clientError(let error):
            return "error with statuscode: \(error)"
        case .unknown:
            return "unknown error"
        }
    }
}


enum ClientErrorStatus: Int {
    case notFound = 404
    case badRequest = 400
    case unauthorized = 301
    case fobidden = 403
    case unknown = 444
}
