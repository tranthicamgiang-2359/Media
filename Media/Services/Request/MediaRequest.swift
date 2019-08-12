//
//  MediaRequest.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import Alamofire

typealias Parameter = [String: String]

protocol MediaRequest {
    var method: HTTPMethod { get }
    var url: String { get }
    var parameter: Parameter? { get }
    var header: [String: String]? { get }
}

extension MediaRequest {
    func buildHeaders() -> HTTPHeaders {
        var headers = [HTTPHeader]()
        if let headerRequest = self.header {
            headerRequest.forEach{ headers.append(HTTPHeader(name: $0, value: $1))}
        }
        return HTTPHeaders(headers)
    }
}
