//
//  OcrView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 4/6/2024.
//

import SwiftUI

internal struct OcrView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var recognizedText = ""

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
            }

            FButton("Pick Image", type: .primary) {
                showImagePicker = true
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }

            FButton("Perform OCR on It", type: .success) {
                if let selectedImage = selectedImage {
                    OCRManager.shared.performOCR(on: selectedImage) { text in
                        recognizedText = text
                    }
                }
            }

            ScrollView {
                Text(recognizedText)
                    .padding()
            }
        }
    }
}
