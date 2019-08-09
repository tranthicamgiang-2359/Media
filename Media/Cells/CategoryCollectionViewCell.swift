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

    
    var bag = DisposeBag()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isAwaked = true
        setupCollectionView()
    }
    
    func setupCollectionView() {
        dataSource = MoviesCollectionViewDataSource()
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    

    
    override func prepareForReuse() {

        categoryLabel.text = nil
        self.bag = DisposeBag()
        super.prepareForReuse()
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
