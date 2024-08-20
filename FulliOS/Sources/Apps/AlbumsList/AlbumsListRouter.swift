//
//  AlbumListRouter.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 3/8/2024.
//

import SwiftUI

internal class AlbumsListRouter: AlbumsListRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToAlbumDetail(for album: Album) {
        AlertManager.shared.showAlert(title: "Album: \(album.id)", message: album.title)
    }
}
