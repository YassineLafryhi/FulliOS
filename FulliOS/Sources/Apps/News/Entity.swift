//
//  Entity.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 15/7/2024.
//

internal struct NewsItem: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

internal struct Source: Codable {
    let id: String?
    let name: String
}
