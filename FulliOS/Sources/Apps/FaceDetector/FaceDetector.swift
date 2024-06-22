//
//  FaceDetector.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 4/6/2024.
//

import SwiftUI
import UIKit

internal struct FaceDetector: View {
    @State private var uiImage: UIImage? = UIImage(contentsOfFile: Bundle.main.path(forResource: "person", ofType: "jpg") ?? "")
    @State private var faceRects: [CGRect] = []

    var body: some View {
        VStack {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .overlay(FaceOverlayView(rects: faceRects, imageSize: uiImage.size))
            }

            FButton("Detect Faces", type: .success) {
                detectFaces()
            }
        }
    }

    private func detectFaces() {
        guard let image = uiImage else {
            return
        }

        FaceManager.shared.detectFaces(in: image) { rects in
            DispatchQueue.main.async {
                faceRects = rects
            }
        }
    }
}
