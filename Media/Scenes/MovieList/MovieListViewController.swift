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
    
    private var dataSource: MediaRxCollectionViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        bind()
    }
    
    func setupCollectionView() {
        dataSource = ListCategoryDataSource()
        
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
            .compactMap { stateVM -> [CategoryViewModel]? in
                switch stateVM {
                case .loading: return nil
                case .success(let categories): return categories
                    
                case .error(_): return nil
                }
            }.bind(to: collectionView.rx.items){ (collectionView, row, element) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: IndexPath(row: row, section: 0))
                return self.dataSource.configure(cell: cell, with: element)
            }.disposed(by: bag)
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 200)
    }
}

class ListCategoryDataSource: MediaRxCollectionViewDataSource {
    func configure<T>(cell: T, with item: Any) -> T where T : UICollectionViewCell {
        guard let listCategoryCell = cell as? CategoryCollectionViewCell, let category = item as? Category else { fatalError() }
        
        listCategoryCell.viewModel = CategoryCellViewModel(service: MovieAPI(), categoryId: category.id, categoryName: category.name)
        return cell
    }
    
    
    
}
