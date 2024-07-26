//
//  WebBrowserView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 26/7/2024.
//

import SwiftUI
import WebKit

internal struct WebBrowserView: View {
    @State private var urlString = "https://www.example.com"
    @State private var webView: WKWebView?
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var isLoading = false
    @State private var showBookmarks = false
    @State private var showHistory = false
    @State private var showDownloads = false

    @StateObject private var bookmarkManager = BookmarkManager()
    @StateObject private var historyManager = HistoryManager()
    @StateObject private var downloadManager = DownloadManager()

    var body: some View {
        VStack {
            HStack {
                TextField("Enter URL", text: $urlString, onCommit: loadPage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: loadPage) {
                    Image(systemName: "arrow.right.circle.fill")
                }
            }.padding()

            if let webView = webView {
                WebViewWrapper(webView: webView, canGoBack: $canGoBack, canGoForward: $canGoForward, isLoading: $isLoading)
            }

            HStack {
                Button(action: goBack) {
                    Image(systemName: "arrow.left")
                }.disabled(!canGoBack)

                Button(action: goForward) {
                    Image(systemName: "arrow.right")
                }.disabled(!canGoForward)

                Button(action: refresh) {
                    Image(systemName: "arrow.clockwise")
                }

                Button(action: { showBookmarks.toggle() }) {
                    Image(systemName: "book")
                }

                Button(action: { showHistory.toggle() }) {
                    Image(systemName: "clock")
                }

                Button(action: { showDownloads.toggle() }) {
                    Image(systemName: "arrow.down.circle")
                }
            }.padding()
        }
        .sheet(isPresented: $showBookmarks) {
            BookmarkView(bookmarks: bookmarkManager.bookmarks) { url in
                urlString = url
                loadPage()
                showBookmarks = false
            }
        }
        .sheet(isPresented: $showHistory) {
            HistoryView(history: historyManager.history) { url in
                urlString = url
                loadPage()
                showHistory = false
            }
        }
        .sheet(isPresented: $showDownloads) {
            DownloadView(downloads: downloadManager.downloads)
        }
        .onAppear {
            setupWebView()
        }
    }

    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        webView = WKWebView(frame: .zero, configuration: configuration)
        loadPage()
    }

    private func loadPage() {
        guard let url = URL(string: urlString) else { return }
        webView?.load(URLRequest(url: url))
        historyManager.addToHistory(urlString)
    }

    private func goBack() {
        webView?.goBack()
    }

    private func goForward() {
        webView?.goForward()
    }

    private func refresh() {
        webView?.reload()
    }
}

internal struct WebViewWrapper: UIViewRepresentable {
    let webView: WKWebView
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_: WKWebView, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewWrapper

        init(_ parent: WebViewWrapper) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish _: WKNavigation) {
            parent.canGoBack = webView.canGoBack
            parent.canGoForward = webView.canGoForward
            parent.isLoading = false
        }

        func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation) {
            parent.isLoading = true
        }
    }
}
