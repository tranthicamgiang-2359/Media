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

    let service: RequestServerMediaProtcol

    let bag = DisposeBag()
    
    let category: Category
    
    init(service: RequestServerMediaProtcol, categoryId: Int, categoryName: String) {
        self.service = service
        self.category = Category(id: categoryId, name: categoryName)
    }
    
}
