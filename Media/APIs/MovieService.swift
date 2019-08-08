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
    func requestCategoryIDs() -> Single<[Category]> {
        let request = GetCategoryRequest()
        return Client().requestArray(request)
        
    }
    
    func requestMovies(by id: Int) -> Single<[Movie]> {
        let request = GetMoviesByIDRequest(categoryId: id)
        return Client().requestArray(request)
    }
    
    
}
