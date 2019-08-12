//
//  UserDefaultStorage.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/12/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation

enum UserDefaultKey: String {
    case token
}

class UserDefaultStorage {
    static let shared = UserDefaultStorage()
    private let userDefault: UserDefaults
    
    init(userDefault: UserDefaults = UserDefaults.standard) {
        self.userDefault = userDefault
    }
    
    func set(value: Any?, for key: String) {
        userDefault.setValue(value, forKey: key)
    }
    
    func value(for key: String) -> Any? {
        return userDefault.value(forKey: key)
    }
    
}
