//
//  NewsRouter.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 15/7/2024.
//

import UIKit

internal class NewsRouter: NewsRouterProtocol {
    func createModule() -> UIViewController {
        let interactor = NewsInteractor()
        let router = NewsRouter()
        let presenter = NewsPresenter(interactor: interactor, router: router)
        let view = NewsViewController()

        view.presenter = presenter
        presenter.view = view
        interactor.presenter = presenter

        return view
    }
}
