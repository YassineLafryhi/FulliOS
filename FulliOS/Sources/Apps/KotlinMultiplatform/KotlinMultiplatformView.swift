//
//  KotlinMultiplatformView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 2/6/2024.
//

import Combine
import SwiftUI

#if targetEnvironment(simulator)
internal struct KotlinMultiplatformView: View {
    var body: some View {
        Text("Not supported yet on Simulator !")
    }
}
#else
import shared

internal class PostsViewModel: ObservableObject {
    @Published var posts: [KMMPost] = []

    func loadPosts() {
        IOSPlatform().fetchPosts(success: { [weak self] posts in
            self?.posts = posts.map { KMMPost(userId: $0.userId, id: $0.id, title: $0.title, body: $0.body) }
        }, failure: { error in
            print("Error fetching posts: \(error)")
        })
    }
}

internal struct KotlinMultiplatformView: View {
    @ObservedObject var viewModel = PostsViewModel()

    var body: some View {
        List(viewModel.posts, id: \.id) { post in
            VStack(alignment: .leading) {
                Text(post.title).fontWeight(.bold)
                Text(post.body).font(.caption)
            }
        }.onAppear {
            viewModel.loadPosts()
        }
    }
}
#endif
