//
//  VCStoryboardInitializable.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    func initViewController<T: UIViewController>() -> T {
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
    
    static var main = UIStoryboard(name: "Main", bundle: nil)
}
