//
//  MovieListViewController.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MovieListViewController: UIViewController, VCStoryboardInitializable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MovieListViewModel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        bind()
    }
    
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
    }
    
    func bind() {
        viewModel.categoryVMs
            .filter {
                switch $0 {
                case .loading: return true
                default: return false
                }
            }.subscribe(onNext: { _ in
                //loading
            })
            .disposed(by: bag)
        
        viewModel.categoryVMs
            .map { (stateVM) -> [CategoryViewModel]? in
                switch stateVM {
                case .success(let categories): return categories
                default: return nil
                }
            }.filter { $0 != nil }
            .map{ return $0 ?? [] }
            .bind(to: collectionView.rx.items) {(collectionView, row, element) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: IndexPath(row: row, section: 0)) as! CategoryCollectionViewCell
                element.movies
                    .bind(to: cell.collectionView.rx.items) { (moviesCollectionView, movieRow, movie) in
                        let movieCell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: IndexPath(row: movieRow, section: 0)) as! MovieCollectionViewCell
                        movieCell.viewModel = MovieCellViewModel(movie: movie)
                        return movieCell
                }.disposed(by: cell.bag)
                
                return cell
            }.disposed(by: bag)

    }

}


extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 200)
    }
}
