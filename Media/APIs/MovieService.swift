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
    func requestCategoryIDs() -> Single<[Category]> {
        return Single<[Category]>.create(subscribe: { (singleEvent) -> Disposable in
            let request = GetCategoryRequest()
            let categoriesObserverble: Single<[Category]> = Client().requestArray(request)
            categoriesObserverble.subscribe(onSuccess: { (categories) in
                let newCategories = categories + categories + categories
                singleEvent(.success(newCategories))
            })
//                .subscribe({ (categories) in
//                    var newCategories = categories + categories
//                    singleEvent(.success(newCategories))
//                })
            return Disposables.create()
        })
    }
    
    func requestMovies(by id: Int) -> Single<[Movie]> {
        let request = GetMoviesByIDRequest(categoryId: id)
        return Client().requestArray(request)
    }
    
    
}
