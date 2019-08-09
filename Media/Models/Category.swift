//
//  Category.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import RxSwift

struct Category {
    let id: Int
    let name: String
}

extension Category: Parser {

    
    init?(from json: JSON) {
        guard let categoryId = json["category_id"] as? Int else { return nil }
        guard let categoryName = json["category_name"] as? String else { return nil }
        self.id = categoryId
        self.name = categoryName
    }
    
    
}


struct CategoryViewModel {
    let id: Int
    let name: String
    let movies: Observable<[Movie]>
}
