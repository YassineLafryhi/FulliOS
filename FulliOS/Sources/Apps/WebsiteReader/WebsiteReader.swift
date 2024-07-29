//
//  WebsiteReader.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import Kingfisher
import SwiftSoup
import SwiftUI

internal enum WebsiteType {
    case blog
    case news
    case forum
}

internal class WebsiteReaderViewModel: ObservableObject {
    @Published var articles: [WebsiteReaderArticle] = []
    @Published var currentPage = 1
    @Published var totalPages = 1
    @Published var searchQuery = ""

    let websiteURL: URL
    let websiteType: WebsiteType
    let articleURLPlaceholder: String
    let contentID: String
    let titleID: String
    let articleImageSourceSelector: String
    let authorSelector = ""
    let dateSelector = ""

    init(
        websiteURL: URL,
        websiteType: WebsiteType,
        articleURLPlaceholder: String,
        contentID: String,
        titleID: String,
        articleImageSourceSelector: String) {
        self.websiteURL = websiteURL
        self.websiteType = websiteType
        self.articleURLPlaceholder = articleURLPlaceholder
        self.contentID = contentID
        self.titleID = titleID
        self.articleImageSourceSelector = articleImageSourceSelector

        fetchArticles()
    }

    func fetchArticles() {
        URLSession.shared.dataTask(with: websiteURL) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let html = try SwiftSoup.parse(String(decoding: data, as: UTF8.self))
                let title = try html.select(self.titleID).text()
                let imageUrl = try html.select(self.articleImageSourceSelector).attr("src")
                let imageSource = try html.select(self.articleImageSourceSelector).text()
                let author = "" // try html.select(self.authorSelector).text()
                let date = "" //  try html.select(self.dateSelector).text()

                let contentElements = try html.select(self.contentID)
                var contentTexts = [String]()
                for element in contentElements.array() {
                    let paragraphText = try element.text()
                    contentTexts.append(paragraphText)
                }

                let content = contentTexts.joined(separator: "\n\n")
                let articleItem = WebsiteReaderArticle(
                    id: Int.random(in: 1 ... 1_000),
                    title: title,
                    imageUrl: imageUrl,
                    imageSource: imageSource,
                    author: author,
                    date: date,
                    content: content)
                DispatchQueue.main.async {
                    self.articles = [
                        articleItem
                    ]
                    self.totalPages = 1
                }
            } catch {
                Logger.shared.log("Error parsing HTML: \(error)")
            }
        }.resume()
    }

    func nextPage() {
        if currentPage < totalPages {
            currentPage += 1
            fetchArticles()
        }
    }

    func previousPage() {
        if currentPage > 1 {
            currentPage -= 1
            fetchArticles()
        }
    }

    func search() {
        // TODO: Implement search logic here
        fetchArticles()
    }
}

internal struct WebsiteReader: View {
    @StateObject private var viewModel: WebsiteReaderViewModel

    init(
        websiteURL: URL,
        websiteType: WebsiteType,
        articleURLPlaceholder: String,
        contentID: String,
        titleID: String,
        articleImageSourceSelector: String) {
        _viewModel = StateObject(wrappedValue: WebsiteReaderViewModel(
            websiteURL: websiteURL,
            websiteType: websiteType,
            articleURLPlaceholder: articleURLPlaceholder,
            contentID: contentID,
            titleID: titleID,
            articleImageSourceSelector: articleImageSourceSelector))
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchQuery, onSearch: viewModel.search)

                List(viewModel.articles) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        Text(article.title)
                    }
                }

                HStack {
                    Button("Previous") {
                        viewModel.previousPage()
                    }
                    .disabled(viewModel.currentPage == 1)

                    Spacer()

                    Text("Page \(viewModel.currentPage) of \(viewModel.totalPages)")

                    Spacer()

                    Button("Next") {
                        viewModel.nextPage()
                    }
                    .disabled(viewModel.currentPage == viewModel.totalPages)
                }
                .padding()
            }
            .navigationTitle("Web Reader")
        }
    }
}

internal struct SearchBar: View {
    @Binding var text: String
    let onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Search") {
                onSearch()
            }
        }
        .padding()
    }
}

internal struct ArticleDetailView: View {
    let article: WebsiteReaderArticle

    var body: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 10) {
                Text(article.title)
                    .font(.custom(R.font.dinNextLTW23Medium.name, size: 24))
                    .foregroundColor(.init(hex: "#2c3e50"))
                    .frame(maxWidth: .infinity, alignment: .center)

                if let imageURL = URL(string: article.imageUrl) {
                    KFImage(imageURL)
                        .resizable()
                        .placeholder {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                }

                Text(article.author)
                    .font(.custom(R.font.dinNextLTW23Medium.name, size: 18))
                    .foregroundColor(.init(hex: "#2c3e50"))
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(article.date)
                    .font(.custom(R.font.dinNextLTW23Medium.name, size: 18))
                    .foregroundColor(.init(hex: "#2c3e50"))
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(article.imageSource)
                    .font(.custom(R.font.dinNextLTW23Medium.name, size: 18))
                    .foregroundColor(.init(hex: "#2c3e50"))
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(article.content)
                    .font(.custom(R.font.dinNextLTW23Medium.name, size: 18))

                // TODO: Add Comments View if supported
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .trailing)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

extension WebsiteReaderViewModel {
    internal func fetchArticlesWithSwiftSoup() {}
}
