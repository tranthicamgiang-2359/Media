//
//  MovieListViewModel.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import RxSwift

class MovieListViewModel {
    
    private let service: RequestServerMediaProtcol
    private let bag = DisposeBag()
    
    private lazy var _categoryVMs: Observable<StateViewModel<[CategoryViewModel]>> = {
        return Observable<StateViewModel<[CategoryViewModel]>>.create({ (observer) -> Disposable in
            observer.onNext(StateViewModel<[CategoryViewModel]>.loading)
            
            self.service.requestCategoryIDs()
                .subscribe(onSuccess: { [weak self](categories) in
                    guard let `self` = self else { return }


                    let categoryVMs = categories.map { category in
                        return CategoryViewModel(id: category.id, name: category.name, movies: self.ob)
                    }
                    
                    observer.onNext(StateViewModel<[CategoryViewModel]>.success(categoryVMs))
                    observer.onCompleted()
                }, onError: { (error) in
                    observer.onError(error)
                })
                .disposed(by: self.bag)
            return Disposables.create()
        }).share()
    }()
    
    var categoryVMs: Observable<StateViewModel<[CategoryViewModel]>> {
        return _categoryVMs
    }
    
    private lazy var _movieObservable: (Int) -> Observable<[Movie]> = { categoryId in
        return self.service.requestMovies(by: categoryId).asObservable().share()
    }
    
    lazy var _ob: Observable<[Movie]> = {
        return self.service.requestMovies(by: 1).asObservable().share()
    }()
    
    var ob: Observable<[Movie]> {
        return _ob
    }
    
    init(service: RequestServerMediaProtcol) {
        self.service = service
    }
}
