//
//  BookmarkManager.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 26/7/2024.
//

import SwiftUI

internal class BookmarkManager: ObservableObject {
    @Published var bookmarks: [String] = []

    func addBookmark(_ url: String) {
        if !bookmarks.contains(url) {
            bookmarks.append(url)
        }
    }

    func removeBookmark(_ url: String) {
        bookmarks.removeAll { $0 == url }
    }
}

internal struct BookmarkView: View {
    let bookmarks: [String]
    let onSelect: (String) -> Void

    var body: some View {
        List(bookmarks, id: \.self) { bookmark in
            Button(action: { onSelect(bookmark) }) {
                Text(bookmark)
            }
        }
    }
}

internal class HistoryManager: ObservableObject {
    @Published var history: [String] = []

    func addToHistory(_ url: String) {
        history.insert(url, at: 0)
    }

    func clearHistory() {
        history.removeAll()
    }
}

internal struct HistoryView: View {
    let history: [String]
    let onSelect: (String) -> Void

    var body: some View {
        List(history, id: \.self) { item in
            Button(action: { onSelect(item) }) {
                Text(item)
            }
        }
    }
}

internal class DownloadManager: ObservableObject {
    @Published var downloads: [Download] = []

    func addDownload(_ download: Download) {
        downloads.append(download)
    }
}

internal struct Download: Identifiable {
    let id = UUID()
    let url: String
    let filename: String
    var progress: Double
}

internal struct DownloadView: View {
    let downloads: [Download]

    var body: some View {
        List(downloads) { download in
            VStack(alignment: .leading) {
                Text(download.filename)
                ProgressView(value: download.progress)
            }
        }
    }
}
