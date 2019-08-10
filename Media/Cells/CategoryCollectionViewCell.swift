//
//  CategoryCollectionViewCell.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import UIKit
import RxSwift

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var isAwaked = false
    
    var viewModel: CategoryViewModel? {
        didSet { bindIfCould()}
    }
    
    var movies = [Movie]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isAwaked = true
        setupCollectionView()
        bindIfCould()
    }

    func bindIfCould() {
        if isAwaked {
            bind()
        }
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        categoryLabel.text = viewModel.name
        viewModel.output.movies
            .drive(onNext: { [weak self] movies in
                self?.movies = movies
            }).disposed(by: bag)
        
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    override func prepareForReuse() {
        self.bag = DisposeBag()
        super.prepareForReuse()
    }
    
}

extension CategoryCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.configureCell(with: MovieCellViewModel(movie: movies[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
    
}


