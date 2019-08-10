//
//  ResultType.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

extension Result {
    var value: T? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    var error: E? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}

extension Result {
    func flatMap<U>(_ tranform: (T) -> U) -> Result<U, E> {
        switch self {
        case .success(let value): return .success(tranform(value))
        case .failure(let error): return .failure(error)
        }
    }
    
}


