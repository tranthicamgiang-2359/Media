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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with viewModel: MovieCellViewModel) {
        imdbLabel.text = "\(viewModel.imdb)"
        if let imageUrl = viewModel.urlImage {
            let resource = ImageResource(downloadURL: imageUrl, cacheKey: "\(imageUrl)")
            imageView.kf.setImage(with: resource)
        }
    }

    override func prepareForReuse() {
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
