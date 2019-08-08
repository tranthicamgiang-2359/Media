//
//  VCStoryboardInitializable.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import UIKit

protocol VCStoryboardInitializable {
    
}

extension VCStoryboardInitializable where Self: UIViewController {
    static func initFromStoryboard(_ storyboard: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: Self.self)) as! Self
    }
}
