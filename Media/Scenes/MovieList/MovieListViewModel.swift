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
    
    lazy var categoryVMs: Observable<StateViewModel<[CategoryViewModel]>> = {
        return Observable<StateViewModel<[CategoryViewModel]>>.create({ (observer) -> Disposable in
            observer.onNext(StateViewModel<[CategoryViewModel]>.loading)
            self.service.requestCategoryIDs()
                .map({ (categories) -> [CategoryViewModel] in
                    return categories
                })
                .subscribe(onSuccess: { (categoryVMs) in
                    observer.onNext(StateViewModel<[CategoryViewModel]>.success(categoryVMs))
                    observer.onCompleted()
                }, onError: { (error) in
                    observer.onError(error)
                })
                .disposed(by: self.bag)
            return Disposables.create()
        }).share()
    }()
    
    init(service: RequestServerMediaProtcol) {
        self.service = service
    }
}
