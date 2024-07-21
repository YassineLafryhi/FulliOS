//
//  NewsInteractor.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 15/7/2024.
//

import Alamofire

internal class NewsInteractor: NewsInteractorProtocol {
    weak var presenter: NewsPresenterProtocol?

    func fetchNews(for query: String) {
        let url = Constants.NewsApp.newsApi
        let parameters: Parameters = [
            "language": "ar",
            "q": query,
            "from": Date().subtracting(days: 20).toString(format: Constants.NewsApp.reversedDateFormat),
            "to": Date().toString(format: Constants.NewsApp.reversedDateFormat),
            "sortBy": "popularity",
            "apiKey": APIKeys.newsApiKey
        ]
        // swiftformat:disable all
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case let .success(value):
                if
                    let dictionary = value as? [String: Any],
                    let articles = dictionary["articles"] as? [[String: Any]] {
                    let decoder = JSONDecoder()
                    if
                        let data = try? JSONSerialization.data(withJSONObject: articles, options: []),
                        let items = try? decoder.decode([NewsItem].self, from: data) {
                          self.presenter?.didFetchNews(items)
                    } else {
                        self.presenter?.didFailToFetchNews("Failed to decode response")
                    }
                } else {
                    self.presenter?.didFailToFetchNews("Invalid response format")
                }
            case let .failure(error):
                self.presenter?.didFailToFetchNews(error.localizedDescription)
            }
        }
        // swiftformat:enable all
    }
}
