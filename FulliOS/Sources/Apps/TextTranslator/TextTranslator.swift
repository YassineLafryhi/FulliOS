//
//  TextTranslator.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 8/6/2024.
//

import Foundation
import SwiftUI

internal struct TextTranslator: View {
    @State private var inputText = ""
    @State private var translatedText = ""
    @State private var selectedLanguage = "en"
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let translationManager = GoogleTranslationManager()
    private let languages = [
        ("ar", "Arabic"),
        ("en", "English"),
        ("es", "Spanish"),
        ("fr", "French"),
        ("de", "German"),
        ("ja", "Japanese"),
        ("sm", "Samoan"),
        ("fi", "Finnish")
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter text to translate:")
                .font(.headline)

            TextEditor(text: $inputText)
                .border(Color.gray, width: 1)
                .padding()
                .frame(height: 150)

            Picker("Select target language", selection: $selectedLanguage) {
                ForEach(languages, id: \.0) { code, name in
                    Text(name).tag(code)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Button(action: {
                translateText()
            }) {
                Text("Translate")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(isLoading)

            if isLoading {
                ProgressView()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                Text("Translated text:")
                    .font(.headline)
                TextEditor(text: $translatedText)
                    .border(Color.gray, width: 1)
                    .padding()
                    .frame(height: 150)
            }
        }
        .padding()
    }

    private func translateText() {
        guard !inputText.isEmpty else {
            return
        }

        isLoading = true
        errorMessage = nil
        translatedText = ""

        translationManager.translate(text: inputText, to: selectedLanguage) { translatedText, error in
            isLoading = false
            if let error = error {
                errorMessage = "Error: \(error.localizedDescription)"
            } else if let translatedText = translatedText {
                self.translatedText = translatedText
            } else {
                errorMessage = "Translation failed. Please try again."
            }
        }
    }
}
