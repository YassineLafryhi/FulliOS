//
//  GeminiModel.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 3/8/2024.
//

import Foundation

internal struct GeminiResponse: Codable {
    let candidates: [GeminiCandidate]
    let usageMetadata: UsageMetadata
}

internal struct UsageMetadata: Codable {
    let promptTokenCount: Int
    let candidatesTokenCount: Int
    let totalTokenCount: Int
}

internal struct GeminiCandidate: Codable {
    let content: GeminiContent
    let finishReason: String
    let index: Int
    let safetyRatings: [GeminiSafetyRating]
}

internal struct GeminiContent: Codable {
    let parts: [GeminiPart]
    let role: String
}

internal struct GeminiPart: Codable {
    let text: String
}

internal struct GeminiSafetyRating: Codable {
    let category: String
    let probability: String
}

internal struct GeminiPromptFeedback: Codable {
    let safetyRatings: [GeminiSafetyRating]
}

internal class GeminiModel {
    static let shared = GeminiModel()
    var apiKey = ""
    var urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

    private init() {}

    func setApiKey(_ apiKey: String) {
        self.apiKey = apiKey
    }

    func generate(prompt: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString + "?key=\(apiKey)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "contents": [
                [
                    "role": "user",
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 1,
                "topK": 64,
                "topP": 0.95,
                "maxOutputTokens": 8_192,
                "responseMimeType": "text/plain"
            ]
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 2, userInfo: nil)))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
