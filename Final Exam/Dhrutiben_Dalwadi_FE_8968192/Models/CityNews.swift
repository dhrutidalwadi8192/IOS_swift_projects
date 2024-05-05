//
//  News.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/13/24.
//

import Foundation

// MARK: - Welcome
struct CityNews: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title, description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
