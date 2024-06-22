//
//  CameraFilterView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 8/6/2024.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

internal struct CameraFilterView: View {
    var image: UIImage?
    @Binding var selectedFilter: CIFilter
    @State private var ciContext = CIContext()

    var body: some View {
        VStack {
            if let uiImage = image {
                let processedImage = applyFilter(to: uiImage)
                Image(uiImage: processedImage)
                    .resizable()
                    .scaledToFit()
            }

            ScrollView(.horizontal) {
                HStack {
                    Button("Sepia") {
                        selectedFilter = CIFilter.sepiaTone()
                    }
                    Button("Noir") {
                        selectedFilter = CIFilter.photoEffectNoir()
                    }
                    Button("Chrome") {
                        selectedFilter = CIFilter.photoEffectChrome()
                    }
                }
            }
            .padding()

            Button("Save to Photos") {
                if let uiImage = image {
                    UIImageWriteToSavedPhotosAlbum(applyFilter(to: uiImage), nil, nil, nil)
                }
            }
        }
    }

    func applyFilter(to image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else {
            return image
        }
        selectedFilter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputImage = selectedFilter.outputImage else {
            return image
        }
        guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        return UIImage(cgImage: cgImage)
    }
}
