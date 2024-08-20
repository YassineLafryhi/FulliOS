//
//  GeminiChatViewModel.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 3/8/2024.
//

import SwiftUI

internal struct GeminiMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

internal class GeminiChatViewModel: ObservableObject {
    @Published var messages: [GeminiMessage] = []
    @Published var inputText = ""
    @Published var isLoading = false

    private let geminiModel = GeminiModel.shared

    init() {
        geminiModel.setApiKey(APIKeys.geminiApiKey)
    }

    func sendMessage() {
        let userMessage = GeminiMessage(text: inputText, isUser: true)
        messages.append(userMessage)
        inputText = ""

        isLoading = true
        geminiModel.generate(prompt: userMessage.text) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(data):
                    if let string = String(data: data, encoding: .utf8) {
                        print(string)
                    }
                    if
                        let response = try? JSONDecoder().decode(GeminiResponse.self, from: data),
                        let geminiText = response.candidates.first?.content.parts.first?.text {
                        let botMessage = GeminiMessage(text: geminiText, isUser: false)
                        self?.messages.append(botMessage)
                    } else {
                        self?.messages.append(GeminiMessage(text: "Failed to parse response", isUser: false))
                    }
                case let .failure(error):
                    self?.messages.append(GeminiMessage(text: "Error: \(error.localizedDescription)", isUser: false))
                }
            }
        }
    }
}
