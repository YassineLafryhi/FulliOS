//
//  DSView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import PDFKit
import SwiftUI
import VisionKit

internal struct DocumentScanner: View {
    @State private var showingScanner = false
    @State private var scannedImages: [UIImage] = []
    @State private var showSavedAlert = false

    var body: some View {
        VStack {
            if !scannedImages.isEmpty {
                ScrollView {
                    ForEach(scannedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
                Button(action: saveToPDF) {
                    Text("Save as PDF")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                Text("No Document Scanned")
                    .font(.headline)
                    .padding()
            }

            Spacer()

            Button(action: {
                showingScanner = true
            }) {
                Text("Scan Document")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .sheet(isPresented: $showingScanner) {
            DocumentScannerView(isPresented: $showingScanner, scannedImages: $scannedImages)
        }
        .alert(isPresented: $showSavedAlert) {
            Alert(title: Text("Success"), message: Text("PDF saved to Files"), dismissButton: .default(Text("OK")))
        }
    }

    private func saveToPDF() {
        let pdfDocument = PDFDocument()

        for (index, image) in scannedImages.enumerated() {
            let pdfPage = PDFPage(image: image)
            pdfDocument.insert(pdfPage!, at: index)
        }

        let data = pdfDocument.dataRepresentation()
        let fileManager = FileManager.default

        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsDirectory = urls.first else { return }

        let fileURL = documentsDirectory.appendingPathComponent("scannedDocument.pdf")

        do {
            try data?.write(to: fileURL)
            showSavedAlert = true
        } catch {
            print("Could not save PDF file: \(error)")
        }
    }
}
