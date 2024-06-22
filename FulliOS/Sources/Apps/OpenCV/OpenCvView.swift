//
//  OpenCvView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 7/6/2024.
//

import SwiftUI
import UIKit

internal struct OpenCvView: View {
    @State private var displayedImage: UIImage? = R.image.personJpg()
    @State private var originalImage: UIImage? = R.image.personJpg()

    var body: some View {
        VStack {
            if let image = displayedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            FButton("Make Image GrayScale", type: .primary) {
                makeImageGrayScale()
            }

            FButton("Apply Gaussian Blur", type: .info) {
                applyGaussianBlur()
            }

            FButton("Flip Image Horizontally", type: .warning) {
                flipImage(vertically: false)
            }

            FButton("Flip Image Vertically", type: .success) {
                flipImage(vertically: true)
            }

            FButton("Set Original Image", type: .danger) {
                setImageToOriginal()
            }
        }
        .padding()
    }

    func makeImageGrayScale() {
        guard let inputImage = displayedImage else {
            return
        }
        let grayImage = OpenCVProcessor.convert(toGrayscale: inputImage)
        displayedImage = grayImage
    }

    func applyGaussianBlur() {
        guard let inputImage = displayedImage else {
            return
        }
        displayedImage = OpenCVProcessor.applyGaussianBlur(inputImage)
    }

    func flipImage(vertically: Bool) {
        guard let inputImage = displayedImage else {
            return
        }
        displayedImage = OpenCVProcessor.flip(inputImage, vertically: vertically)
    }

    func setImageToOriginal() {
        displayedImage = originalImage
    }
}
