//
//  Category.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import RxSwift

struct Category: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "category_id"
        case name = "category_name"
    }
}
