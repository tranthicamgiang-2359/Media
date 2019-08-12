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
        return Client().request(request)
            .map({ (result) -> Result<[Category], NetworkError> in
                result.flatMap({ (data) -> [Category] in
                    let decoder = JSONDecoder()
                    let value = try? decoder.decode(DataArrayResponse<Category>.self, from: data)
                    return value?.data ?? []
                })
            })
    }
    
    func requestMovies(by id: Int) -> Single<Result<[Movie], NetworkError>> {
        let request = GetMoviesByIDRequest(categoryId: id)
        return Client().request(request)
            .map({ (result) -> Result<[Movie], NetworkError> in
                result.flatMap({ (data) -> [Movie] in
                    let decoder = JSONDecoder()
                    let value = try? decoder.decode(DataArrayResponse<Movie>.self, from: data)
                    return value?.data ?? []
                })
            })
    }
    
}
