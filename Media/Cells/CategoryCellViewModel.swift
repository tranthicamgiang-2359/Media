//
//  CategoryCellViewModel.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import RxSwift

struct CategoryCellViewModel {
    
    var items: Observable<StateViewModel<[Movie]>> {
        return Observable<StateViewModel<[Movie]>>.create { (observer) -> Disposable in
            observer.onNext(StateViewModel<[Movie]>.loading)
            self.service.requestMovies(by: self.category.id)
                .subscribe(onSuccess: { (movies) in
                    observer.onNext(StateViewModel<[Movie]>.success(movies))
                }, onError: { (error) in
                    observer.onNext(StateViewModel<[Movie]>.error(error))
                })
                .disposed(by: self.bag)
            return Disposables.create()
        }.share()
    }
    let service: RequestServerMediaProtcol

    let bag = DisposeBag()
    
    let category: Category
    
    init(service: RequestServerMediaProtcol, categoryId: Int, categoryName: String) {
        self.service = service
        self.category = Category(id: categoryId, name: categoryName)
    }
    
}
