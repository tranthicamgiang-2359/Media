//
//  CategoryViewModel.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/10/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CategoryViewModel: ViewModelType {
    private let model: Category
    let service: RequestServerMediaProtcol
    
    struct Input {
//        let reloadObserver: AnyObserver<Void>
    }
    
    struct Output {
        let movies: Driver<[Movie]>
        let error: Driver<NetworkError>
    }
    
    var input: Input
    var output: Output
    var id: Int {
        return model.id
    }
    
    var name: String {
        return model.name
    }
    
    private var errorRequestMovieSubject = PublishSubject<NetworkError>()
    private var moviesSubject = PublishSubject<[Movie]>()
//    private var reloadSubject = PublishSubject<Void>()
    private let bag = DisposeBag()
    
    init(id: Int, name: String, service: RequestServerMediaProtcol) {
        self.model = Category(id: id, name: name)
        self.service = service
        
        self.input = Input()
        self.output = Output(movies: moviesSubject.asDriver(onErrorJustReturn: []),
                             error: errorRequestMovieSubject.asDriver(onErrorJustReturn: .unknown))
        
        loadMovies()
    }
    
    private func loadMovies() {
        let moviesRequested = self.service.requestMovies(by: self.model.id)
            .asObservable().share(replay: 1)
        
        moviesRequested
            .compactMap { $0.error }
            .bind(to: errorRequestMovieSubject)
            .disposed(by: bag)
        
        moviesRequested
            .compactMap { $0.value }
            .bind(to: moviesSubject)
            .disposed(by: bag)
    }
}
