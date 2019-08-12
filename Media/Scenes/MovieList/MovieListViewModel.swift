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
        let reloadCategory: Driver<CategoryViewModel>
    }
    
    let service: RequestServerMediaProtcol
    var input: Input
    var output: Output
    
    private let reloadSubject = PublishSubject<Void>()
    private let reloadCategorySubject = PublishSubject<CategoryViewModel>()
    private let categorySubject = PublishSubject<[CategoryViewModel]>()
    private let errorRequestSubject = PublishSubject<NetworkError>()
    
    private var bag = DisposeBag()
    
    init(service: RequestServerMediaProtcol) {
        self.service = service
        self.input = Input(reloadObserver: reloadSubject.asObserver())
        self.output = Output(categories: categorySubject.asDriver(onErrorJustReturn: []),
                             error: errorRequestSubject.asDriver(onErrorJustReturn: .unknown),
                             reloadCategory: reloadCategorySubject.asDriver(onErrorJustReturn: CategoryViewModel(id: 0, name: "", movies: [])))
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
        
        let categoryViewModelRequested = categoryRequested
            .compactMap { $0.value }
            .map({ (categories) -> [CategoryViewModel] in
                categories.map{ CategoryViewModel(id: $0.id, name: $0.name, movies: [])}
            }).share()
        categoryViewModelRequested
            .bind(to: categorySubject)
            .disposed(by: bag)
        

        categoryRequested
            .compactMap { $0.value }
            .flatMap { categories -> Observable<CategoryViewModel> in
                return Observable.from(categories.map({ (category) -> Observable<CategoryViewModel> in
                    return MovieAPI().requestMovies(by: category.id)
                        .asObservable()
                        .compactMap { $0.value }
                        .map { CategoryViewModel(id: category.id, name: category.name, movies: $0)}
                })).merge()
                
            }
            .bind(to: reloadCategorySubject)
            .disposed(by: bag)
    }
}
