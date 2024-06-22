//
//  PDFCreator.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 7/6/2024.
//

import PDFKit
import UIKit

internal class PDFCreator {
    static let shared = PDFCreator()

    func createPDF(from text: String, withFont font: UIFont, fileName: String) -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "FulliOS",
            kCGPDFContextAuthor: "Author",
            kCGPDFContextTitle: "Title"
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let pdfData = renderer.pdfData { context in
            context.beginPage()

            let attributes: [NSAttributedString.Key: Any] = [
                .font: font
            ]

            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.draw(in: CGRect(x: 20, y: 20, width: pageWidth - 40, height: pageHeight - 40))
        }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pdfURL = documentsDirectory.appendingPathComponent("\(fileName).pdf")

        do {
            try pdfData.write(to: pdfURL)
            return pdfURL
        } catch {
            Logger.shared.log("Could not create PDF file: \(error)", level: .error)
            return nil
        }
    }
}
