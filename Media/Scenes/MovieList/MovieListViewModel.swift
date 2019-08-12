//
//  MovieListViewModel.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListViewModel: ViewModelType {
    struct Input {
        let reloadObserver: AnyObserver<Void>
    }
    
    struct Output {
        let categories: Driver<[CategoryViewModel]>
        let error: Driver<NetworkError>
    }
    
    let service: RequestServerMediaProtcol
    var input: Input
    var output: Output
    
    private let reloadSubject = PublishSubject<Void>()
    private let categorySubject = PublishSubject<[CategoryViewModel]>()
    private let errorRequestSubject = PublishSubject<NetworkError>()
    
    private var bag = DisposeBag()
    
    init(service: RequestServerMediaProtcol) {
        self.service = service
        self.input = Input(reloadObserver: reloadSubject.asObserver())
        self.output = Output(categories: categorySubject.asDriver(onErrorJustReturn: []),
                             error: errorRequestSubject.asDriver(onErrorJustReturn: .unknown))
        setupRefresh()
        bind()
        

    }
    
    private func setupRefresh() {
        bag = DisposeBag()
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.bind()
            }).disposed(by: bag)
    }

    private func bind() {
        let categoryRequested = self.service.requestCategoryIDs()
            .asObservable().share(replay: 1)
        
        categoryRequested
            .compactMap { $0.error }
            .bind(to: errorRequestSubject)
            .disposed(by: bag)
        
        categoryRequested
            .compactMap { $0.value }
            .map({ (categories) -> [CategoryViewModel] in
                var categoryVMs = [CategoryViewModel]()
                categories.forEach { categoryVMs.append(CategoryViewModel(id: $0.id, name: $0.name, service: self.service)) }
                return categoryVMs
            })
            .subscribe(onNext: { (categories) in
                self.categorySubject.onNext(categories)
            })
            .disposed(by: bag)
    }
}
