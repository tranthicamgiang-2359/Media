//
//  DataArrayResponse.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/12/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation

struct DataArrayResponse<T: Codable>: Codable {
    let data: [T]
}
