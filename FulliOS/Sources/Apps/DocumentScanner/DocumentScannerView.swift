//
//  DocumentScannerView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import PDFKit
import SwiftUI
import VisionKit

internal struct DocumentScannerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var scannedImages: [UIImage]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }

    func updateUIViewController(_: VNDocumentCameraViewController, context _: Context) {}

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: DocumentScannerView

        init(_ parent: DocumentScannerView) {
            self.parent = parent
        }

        func documentCameraViewController(_: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            for pageIndex in 0 ..< scan.pageCount {
                let scannedImage = scan.imageOfPage(at: pageIndex)
                parent.scannedImages.append(scannedImage)
            }
            parent.isPresented = false
        }

        func documentCameraViewControllerDidCancel(_: VNDocumentCameraViewController) {
            parent.isPresented = false
        }

        func documentCameraViewController(_: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.isPresented = false
            print("Failed to scan document: \(error.localizedDescription)")
        }
    }
}

extension PDFDocument {
    convenience init(images: [UIImage]) {
        self.init()
        for (index, image) in images.enumerated() {
            if let pdfPage = PDFPage(image: image) {
                insert(pdfPage, at: index)
            }
        }
    }
}
