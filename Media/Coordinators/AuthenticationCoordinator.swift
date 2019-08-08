//
//  AuthenticationCoordinator.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import UIKit

protocol AuthenticationCoordinatorDelegate: class {
    func didFinishAuthentication(with user: User)
}

class AuthenticationCoordinator: Coordinator {

    
    var childCoordinators = [Coordinator]()
    weak var delegate: AuthenticationCoordinatorDelegate?

    func start(by transitionType: TransitionType?) {
        let loginVC = LoginViewController.initFromStoryboard()
        let viewModel = LoginViewModel(loginService: AuthenticationAPI(baseUrl: ""))
        loginVC.viewModel = viewModel
        loginVC.delegate = self
        guard let transitionType = transitionType else {
            assertionFailure()
            return
        }
        transition(to: loginVC, by: transitionType)

    }
}

extension AuthenticationCoordinator: LoginViewControllerDelegate {
    func didLoginSuccessfully(with user: User) {
        delegate?.didFinishAuthentication(with: user)
    }
    
    
}
