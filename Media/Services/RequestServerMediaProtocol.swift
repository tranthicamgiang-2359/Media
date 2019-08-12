//
//  RequestServerMediaProtocol.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import RxSwift

protocol RequestServerMediaProtcol {
    func requestCategoryIDs() -> Single<Result<[Category], NetworkError>>
    
    func requestMovies(by id: Int) -> Single<Result<[Movie], NetworkError>>
    
}


