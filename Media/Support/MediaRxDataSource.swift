//
//  MediaRxDataSource.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/8/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import UIKit

protocol MediaRxCollectionViewDataSource {
    func configure<T: UICollectionViewCell>(cell: T, with item: Any) -> T
}
