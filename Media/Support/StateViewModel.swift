//
//  StateViewModel.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation

enum StateViewModel<T> {
    case loading
    case success(T)
    case error(Error)
}

protocol ViewModel {
    associatedtype Input
    associatedtype Output
}
