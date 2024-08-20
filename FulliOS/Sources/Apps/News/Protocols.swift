//
//  Protocols.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 15/7/2024.
//

import UIKit

internal protocol NewsInteractorProtocol: AnyObject {
    func fetchNews(for query: String)
}

internal protocol NewsPresenterProtocol: AnyObject {
    func fetchNews(for query: String)
    func didFetchNews(_ news: [NewsItem])
    func didFailToFetchNews(_ error: String)
}

internal protocol NewsViewProtocol: AnyObject {
    func showNews(_ news: [NewsItem])
    func showError(_ error: String)
}

internal protocol NewsRouterProtocol: AnyObject {
    func createModule() -> UIViewController
}
