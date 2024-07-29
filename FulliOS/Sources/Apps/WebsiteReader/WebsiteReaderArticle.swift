//
//  WebsiteReaderArticle.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

internal struct WebsiteReaderArticle: Identifiable, Codable {
    var id: Int
    var title: String
    var imageUrl: String
    var imageSource: String
    var author: String
    var date: String
    var content: String
}
