//
//  Model.swift
//  MovieApp
//
//  Created by Anas Salah on 30/04/2024.
//

import Foundation

// MARK: - WelcomeElement
struct MoviesPojo: Codable {
    let title: String
    let year: Int
    let genre: [String]
    let rating: Double
    let poster: String
}
