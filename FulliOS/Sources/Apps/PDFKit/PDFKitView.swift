//
//  PDFKitView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 7/6/2024.
//

import PDFKit
import SwiftUI

internal struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context _: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context _: Context) {
        uiView.document = PDFDocument(url: url)
    }
}
