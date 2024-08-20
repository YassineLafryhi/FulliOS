//
//  AlbumListPresenter.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 3/8/2024.
//

import SwiftUI

internal class AlbumsListPresenter: ObservableObject, AlbumsListPresenterProtocol {
    @Published var albums: [Album] = []

    private let interactor: AlbumsListInteractorProtocol
    private let router: AlbumsListRouterProtocol

    init(interactor: AlbumsListInteractorProtocol, router: AlbumsListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidAppear() {
        interactor.fetchAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(albums):
                    self?.albums = albums
                case let .failure(error):
                    self?.showError(error)
                }
            }
        }
    }

    func showError(_ error: Error) {
        AlertManager.shared.showAlert(title: "Error", message: error.localizedDescription)
    }

    func didSelectAlbum(_ album: Album) {
        router.navigateToAlbumDetail(for: album)
    }
}
