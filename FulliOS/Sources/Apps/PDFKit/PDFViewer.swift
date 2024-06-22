//
//  PDFContentView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 7/6/2024.
//

import PDFKit
import SwiftUI

internal struct PDFViewer: View {
    var body: some View {
        if let font = R.font.dinNextLTW23Medium(size: 28) {
            if let url = PDFCreator.shared.createPDF(from: "بسم الله الرحمن الرحيم", withFont: font, fileName: "example") {
                PDFKitView(url: url)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("PDF file not found.")
            }
        }
    }
}
