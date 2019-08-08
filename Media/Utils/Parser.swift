//
//  Parser.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]
protocol Parser {
    init?(from json: JSON)
}


extension Array where Element: Parser {
    init?(from jsons: [JSON]) {
        self = jsons.compactMap({ item -> Element? in
            return Element(from: item)
        })
    }
    
    
}
