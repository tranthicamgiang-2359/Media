//
//  MovieService.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class MovieAPI: RequestServerMediaProtcol {
    let bag = DisposeBag()
    func requestCategoryIDs() -> Single<Result<[Category], NetworkError>> {
        let request = GetCategoryRequest()
        return Client().requestArray(request)
            .map({ (result) -> Result<[Category], NetworkError> in
                return result.flatMap { $0 + $0 + $0 } // I need more categoriessss
            })
    }
    
    func requestMovies(by id: Int) -> Single<Result<[Movie], NetworkError>> {
        let request = GetMoviesByIDRequest(categoryId: id)
        return Client().requestArray(request)
    }
    
    
}
