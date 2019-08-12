//
//  Movie.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation

struct Movie {
    let id: String
    let title: String
    let cover: String
    let imdbRating: Double
}

extension Movie: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover
        case imdbRating = "imdb_rating"
    }
}

typealias MovieViewModel = Movie
