//
//  GetMoviesByIDRequest.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import Alamofire

struct GetMoviesByIDRequest: MediaRequest {
    var method: HTTPMethod = .get
    
    var url: String {
        return "https://demo6492027.mockable.io/category/\(self.categoryId)"
    }
    
    var parameter: Parameter?
    
    var header: [String : String]?
    
    let categoryId: Int
    
    init(categoryId: Int) {
        self.categoryId = categoryId
    }
}
