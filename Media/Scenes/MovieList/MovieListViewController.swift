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
import RxCocoa

class MovieListViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var categories = [CategoryViewModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var viewModel: MovieListViewModel!
    private var refreshControl = UIRefreshControl()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies"
        setupCollectionView()
        bind()
        
    }
    
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.refreshControl = refreshControl
    }
    
    private func bind() {

        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.reloadObserver)
            .disposed(by: bag)
        
        viewModel.output.error.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                
            }).disposed(by: bag)
        
        viewModel.output.categories
            .drive(onNext: { [weak self] categories in
                self?.refreshControl.endRefreshing()
                self?.categories = categories
            }).disposed(by: bag)
    }

}

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.viewModel = categories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
}
