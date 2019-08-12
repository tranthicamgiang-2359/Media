//
//  Client.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class Client {
    
    func request(_ request: MediaRequest) -> Single<Result<Data, NetworkError>> {
       
        return Single<Result<Data, NetworkError>>.create(subscribe: { (single) -> Disposable in
            AF.request(request.url,
                       method: request.method,
                       parameters: request.parameter,
                       encoder: MediaJSONParameterEncoder.default,
                       headers: request.buildHeaders())
                .responseJSON(completionHandler: { (dataResponse) in
                    print("======= \(String(describing: dataResponse.request?.url))")
                    var error: NetworkError?
                    switch dataResponse.result {
                    case .success(_):
                        if let statusCode = dataResponse.response?.statusCode, let clientError = ClientErrorStatus.init(rawValue: statusCode) {
                            error = .clientError(clientError)
                        }
                    case .failure(let e):
                        error = .serverResponse(e.localizedDescription)
                    }
                    
                    if let networkError = error {
                        single(.success(.failure(networkError)))
                    } else if let data = dataResponse.data {
                        single(.success(.success(data)))
                    }
                })
            return Disposables.create()
        })
    }
    
    
}
