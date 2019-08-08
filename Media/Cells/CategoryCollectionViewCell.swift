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
    
    private var isAwaked: Bool = false
    
    var dataSource: MediaRxCollectionViewDataSource?
    private var bag: DisposeBag? {
        return viewModel?.bag
    }
    
    var viewModel: CategoryCellViewModel? {
        didSet {
            self.callBindIfCould()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isAwaked = true
        setupCollectionView()
        callBindIfCould()
        
        // Initialization code
    }
    
    func setupCollectionView() {
        dataSource = MoviesCollectionViewDataSource()
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    func callBindIfCould() {
        if isAwaked {
            bind()
        }
    }
    func bind() {
        guard let viewModel = viewModel, let bag = bag else { return }
        viewModel.items
            .compactMap { (stateViewModel) -> [Movie]? in
                switch stateViewModel {
                case .success(let movies): return movies
                default: return nil
                }
            }.bind(to: collectionView.rx.items){ [weak self] (collectionView, row, element) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: IndexPath(row: row, section: 0))
                return self?.dataSource?.configure(cell: cell, with: element) ?? UICollectionViewCell()
            }.disposed(by: bag)
        categoryLabel.text = viewModel.category.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataSource = nil
        categoryLabel.text = nil
        
    }

}

extension CategoryCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}

class MoviesCollectionViewDataSource: MediaRxCollectionViewDataSource {
    func configure<T>(cell: T, with item: Any) -> T where T : UICollectionViewCell {
        guard let movieCell = cell as? MovieCollectionViewCell, let movie = item as? Movie else { fatalError() }
        movieCell.viewModel = MovieCellViewModel(movie: movie)
        return cell
    }
}
