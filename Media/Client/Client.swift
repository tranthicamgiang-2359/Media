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
    
    func request<T: Parser>(_ request: MediaRequest) -> Single<T> {
        return Single<T>.create(subscribe: { (singleEvent) -> Disposable in
            AF.request(request.url,
                       method: request.method,
                       parameters: request.parameter,
                       encoder: MediaJSONParameterEncoder.default,
                       headers: request.buildHeaders())
                .responseJSON(completionHandler: { (dataResponse) in
                    var error: NetworkError?
                    var json: JSON?
                    switch dataResponse.result {
                    case .success(let value):
                        if let statusCode = dataResponse.response?.statusCode {
                            error = .clientError(ClientErrorStatus.init(rawValue: statusCode) ?? ClientErrorStatus.unknown)
                        }
                        
                        json = value as? JSON
                    case .failure(let e):
                        error = .serverResponse(e.localizedDescription)
                    }
                    if let _ = error {
                        singleEvent(.error(error!))
                    } else if let jsonValue = json, let result =  T(from: jsonValue){
                        singleEvent(.success(result))
                    }
                })
            return Disposables.create()
        })
        
    }
    
    func requestArray<T: Parser>(_ request: MediaRequest) -> Single<[T]> {
        return Single<[T]>.create(subscribe: { (singleEvent) -> Disposable in
            AF.request(request.url,
                       method: request.method,
                       parameters: request.parameter,
                       encoder: MediaJSONParameterEncoder.default,
                       headers: request.buildHeaders())
                .responseJSON(completionHandler: { (dataResponse) in
                    print("======= \(dataResponse.request?.url)")
                    var error: NetworkError?
                    var json: JSON?
                    switch dataResponse.result {
                    case .success(let value):
                        if let statusCode = dataResponse.response?.statusCode, let clientError = ClientErrorStatus.init(rawValue: statusCode) {
                            error = .clientError(clientError)
                        }
                        
                        json = value as? JSON
                    case .failure(let e):
                        error = .serverResponse(e.localizedDescription)
                    }
                    if let _ = error {
                        singleEvent(.error(error!))
                    } else if let jsonData = json?["data"] as? [JSON], let result =  Array<T>(from: jsonData ) {
                        
                        singleEvent(.success(result))
                    }
                })
            return Disposables.create()
        })
    }
    
    
}
