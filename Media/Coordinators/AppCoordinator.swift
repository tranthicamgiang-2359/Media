//
//  AppCoordinator.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    let window: UIWindow
    
    private var token: String? = ""
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start(by transitionType: TransitionType?) {
        if token == nil {
            startAuthentication()
        } else {
            startAuthenticated()
        }
    }
    
    private func startAuthentication() {
        let authenticationCoordinator = AuthenticationCoordinator()
        authenticationCoordinator.start(by: TransitionType.root(window))
    }
    
    private func startAuthenticated() {
        let listMovieCoordinator = ListMovieCoordinator()
        listMovieCoordinator.start(by: TransitionType.root(window))
    }
    
}

extension AppCoordinator: AuthenticationCoordinatorDelegate {
    func didFinishAuthentication(with user: User) {
        startAuthenticated()
    }
    
    
}
