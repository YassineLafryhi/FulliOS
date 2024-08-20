//
//  AlbumsListProtocols.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 3/8/2024.
//

import SwiftUI

internal protocol AlbumsListViewProtocol: AnyObject {
    func updateAlbums(_ albums: [Album])
    func showError(_ error: Error)
}

internal protocol AlbumsListInteractorProtocol: AnyObject {
    func fetchAlbums(completion: @escaping (Result<[Album], Error>) -> Void)
}

internal protocol AlbumsListPresenterProtocol: ObservableObject {
    var albums: [Album] { get }

    func viewDidAppear()
    func showError(_ error: Error)
}

internal protocol AlbumsListRouterProtocol: AnyObject {
    func navigateToAlbumDetail(for album: Album)
}
