//
//  HttpRequestBuilder.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 15/7/2024.
//

import Alamofire
import Foundation
import SwiftUI

internal struct HttpRequestData {
    var requestType: String
    var url: String
    var queryParams: String
    var requestBody: String
    var headers: String
}

internal class HttpRequestViewModel: ObservableObject {
    @Published var requestData = HttpRequestData(requestType: "GET", url: "", queryParams: "", requestBody: "", headers: "")
    @Published var responseText = ""

    let requestTypes = ["GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"]

    func sendRequest() {
        guard var urlComponents = URLComponents(string: requestData.url) else {
            responseText = "Invalid URL"
            return
        }

        if !requestData.queryParams.isEmpty {
            let queryItems = requestData.queryParams.split(separator: "&").map { param -> URLQueryItem in
                let keyValue = param.split(separator: "=")
                return URLQueryItem(name: String(keyValue[0]), value: String(keyValue[1]))
            }
            urlComponents.queryItems = queryItems
        }

        guard let finalURL = urlComponents.url else {
            responseText = "Invalid URL"
            return
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = requestData.requestType

        if !requestData.requestBody.isEmpty, let bodyData = requestData.requestBody.data(using: .utf8) {
            request.httpBody = bodyData
        }

        if !requestData.headers.isEmpty {
            let headersArray = requestData.headers.split(separator: ";")
            for header in headersArray {
                let keyValue = header.split(separator: "=")
                if keyValue.count == 2 {
                    request.setValue(String(keyValue[1]), forHTTPHeaderField: String(keyValue[0]))
                }
            }
        }

        AF.request(request).responseJSON { response in
            switch response.result {
            case let .success(value):
                if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
                    self.responseText = String(data: jsonData, encoding: .utf8) ?? "Failed to parse response"
                }
            case let .failure(error):
                self.responseText = "Error: \(error.localizedDescription)"
            }
        }
    }
}
