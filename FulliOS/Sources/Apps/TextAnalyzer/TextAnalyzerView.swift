//
//  TextAnalyzerView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/7/2024.
//

import SwiftUI

internal struct TextAnalyzerView: View {
    @State private var inputText = ""
    @State private var wordCount = 0
    @State private var characterCount = 0
    @State private var sentimentScore = 0.0

    var body: some View {
        VStack {
            TextEditor(text: $inputText)
                .frame(height: 200)
                .border(Color.gray, width: 1)
                .padding()

            Button("Analyze Text") {
                analyzeText()
            }
            .padding()

            VStack(alignment: .leading, spacing: 10) {
                Text("Word count: \(wordCount)")
                Text("Character count: \(characterCount)")
                Text("Sentiment score: \(String(format: "%.2f", sentimentScore))")
                    .foregroundColor(sentimentColor)
            }
            .padding()
        }
        .padding()
        .frame(width: 400, height: 400)
    }

    private func analyzeText() {
        wordCount = RustBridge.countWords(inputText)
        characterCount = RustBridge.countCharacters(inputText)
        sentimentScore = RustBridge.simpleSentimentAnalysis(inputText)
    }

    private var sentimentColor: Color {
        if sentimentScore > 0 {
            .green
        } else if sentimentScore < 0 {
            .red
        } else {
            .gray
        }
    }
}
