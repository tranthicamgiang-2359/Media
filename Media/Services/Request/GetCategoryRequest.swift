//
//  GetCategoryRequest.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import Alamofire

struct GetCategoryRequest: MediaRequest {
    var method: HTTPMethod = .get
    
    var url: String {
        return "https://demo6492027.mockable.io/home"
    }
    
    var parameter: Parameter?
    
    var header: [String : String]?
    
    init() {}
}
