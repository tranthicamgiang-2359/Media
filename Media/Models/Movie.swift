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

extension Movie: Parser {
    init?(from json: JSON) {
        guard let id = json["id"] as? String else { return nil }
        guard let title = json["title"] as? String else { return nil }
        guard let cover = json["cover"] as? String else { return nil }
        guard let rating = json["imdb_rating"] as? Double else { return nil }
        
        self.id = id
        self.title = title
        self.cover = cover
        self.imdbRating = rating
    }
    
    
}
