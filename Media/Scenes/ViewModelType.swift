//
//  ViewModelType.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/10/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
