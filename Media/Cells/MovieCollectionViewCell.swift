//
//  MovieCollectionViewCell.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/8/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imdbLabel: UILabel!
    
    var viewModel: MovieCellViewModel? {
        didSet {
            bind()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        if let imageUrl = viewModel.urlImage {
            imageView.kf.setImage(with: imageUrl)
        }
        imdbLabel.text = "\(viewModel.imdb)"
    }

    override func prepareForReuse() {
        viewModel = nil
        imageView.image = nil
        imdbLabel.text = nil
        super.prepareForReuse()
    }
}


struct MovieCellViewModel {
    private let movie: Movie
    var movieTitle: String {
        return movie.title
    }
    
    var urlImage: URL? {
        return URL(string: movie.cover)
    }
    
    var imdb: String {
        let roundedImdb = Double(round((movie.imdbRating * 10)/10))
        return "\(roundedImdb)"
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}
