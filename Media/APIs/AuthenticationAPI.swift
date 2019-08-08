//
//  AuthenticationAPI.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthenticationService {
    var baseUrl: String { get set }
    func login(email: String, password: String) -> Single<User>
}

class AuthenticationAPI: AuthenticationService {
    var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func login(email: String, password: String) -> Single<User> {
        return Single<User>.create(subscribe: { (singleEven) -> Disposable in
            guard email == "takehome@2359media.com" else {
                singleEven(.error(AuthenticationError.wrongEmail))
                return Disposables.create()
            }
            
            guard password == "1Faraday@" else {
                singleEven(.error(AuthenticationError.wrongPassword))
                return Disposables.create()
            }
            
            singleEven(.success(User()))
            return Disposables.create()
        })
    }
    
    
}
