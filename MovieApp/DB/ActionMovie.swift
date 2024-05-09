//
//  ActionMovie.swift
//  MovieApp
//
//  Created by Anas Salah on 22/04/2024.
//

import Foundation
import UIKit

struct ActionMovie {
    let title: String
    let imageData: Data?
    let rating: Int
    let releaseYear: Int
    let genre: [String]
}



var moviesStatic: [ActionMovie] = [
    ActionMovie(title: "The Matrix", imageData: nil, rating: 8, releaseYear: 1999, genre: ["Action", "Sci-Fi"]),
    ActionMovie(title: "Die Hard", imageData: nil, rating: 8, releaseYear: 1988, genre: ["Action", "Thriller"]),
    ActionMovie(title: "Mad Max: Fury Road", imageData: nil, rating: 8, releaseYear: 2015, genre: ["Action", "Adventure"]),
    ActionMovie(title: "John Wick", imageData: nil, rating: 7, releaseYear: 2014, genre: ["Action", "Crime"]),
    ActionMovie(title: "The Dark Knight", imageData: nil, rating: 9, releaseYear: 2008, genre: ["Action", "Crime", "Drama"])
]
