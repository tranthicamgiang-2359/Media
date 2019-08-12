//
//  Validator.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/12/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation

class Validator {
    static func validate(email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: ".+@.+", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }
    
    static func validate(password: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[!&^%$#@()/]).{8}", options: .caseInsensitive)
        return regex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.utf16.count)) != nil
    }
}
