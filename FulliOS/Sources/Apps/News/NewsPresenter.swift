//
//  NewsPresenter.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 15/7/2024.
//

internal class NewsPresenter: NewsPresenterProtocol {
    weak var view: NewsViewProtocol?
    var interactor: NewsInteractorProtocol
    var router: NewsRouterProtocol

    init(interactor: NewsInteractorProtocol, router: NewsRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func fetchNews(for query: String) {
        interactor.fetchNews(for: query)
    }

    func didFetchNews(_ news: [NewsItem]) {
        view?.showNews(news)
    }

    func didFailToFetchNews(_ error: String) {
        view?.showError(error)
    }
}
