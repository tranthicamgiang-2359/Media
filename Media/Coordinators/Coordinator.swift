//
//  Coordinator.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import UIKit


protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    func start(by transitionType: TransitionType?)
}

extension Coordinator {
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func transition(to viewController: UIViewController, by transitionType: TransitionType, additionalSetup: EmptyBlock? = nil) {
        switch transitionType {
        case .root(let window):
            let navigationController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navigationController
        case .push(let navigationController):
            navigationController.pushViewController(viewController, animated: true)
        case .present(let parentVC):
            parentVC.present(viewController, animated: true, completion: nil)
        }
    }
}

enum TransitionType {
    case root(UIWindow)
    case push(UINavigationController)
    case present(UIViewController)
}
