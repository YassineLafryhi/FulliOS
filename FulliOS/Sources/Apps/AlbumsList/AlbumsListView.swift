//
//  AlbumListView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 3/8/2024.
//

import SwiftUI

internal struct AlbumsListView: View {
    @ObservedObject var presenter = AlbumsListPresenter(interactor: AlbumsListInteractor(), router: AlbumsListRouter())

    var body: some View {
        NavigationView {
            List(presenter.albums) { album in
                VStack(alignment: .leading) {
                    Text(album.title)
                        .font(.headline)
                    Text("ID: \(album.id)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .onTapGesture {
                    presenter.didSelectAlbum(album)
                }
            }
            .navigationTitle("Albums")
            .onAppear {
                presenter.viewDidAppear()
            }
        }.withAlert()
    }
}
