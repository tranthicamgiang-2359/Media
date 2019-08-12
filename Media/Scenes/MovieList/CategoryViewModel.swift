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

class CategoryViewModel {
    private let model: Category
    var movies = [Movie]()
    var id: Int {
        return model.id
    }
    
    var name: String {
        return model.name
    }
    
    init(id: Int, name: String, movies: [Movie]) {
        self.model = Category(id: id, name: name)
        self.movies = movies
    }
    
}
