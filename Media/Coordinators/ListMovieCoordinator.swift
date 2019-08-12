//
//  ListMovieCoordinator.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import UIKit

class ListMovieCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    func start(by transitionType: TransitionType?) {
        let movieListVC: MovieListViewController = UIStoryboard.main.initViewController()
        movieListVC.viewModel = MovieListViewModel(service: MovieAPI())
        transition(to: movieListVC, by: transitionType!)
    }
}
