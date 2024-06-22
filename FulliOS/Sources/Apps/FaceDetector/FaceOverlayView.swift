//
//  FaceOverlayView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 4/6/2024.
//

import SwiftUI

internal struct FaceOverlayView: View {
    var rects: [CGRect]
    var imageSize: CGSize

    var body: some View {
        GeometryReader { geometry in
            let scale = geometry.size.width / imageSize.width
            ForEach(0 ..< rects.count, id: \.self) { index in
                let rect = rects[index]
                Rectangle()
                    .frame(width: rect.size.width * scale, height: rect.size.height * scale)
                    .position(
                        x: rect.origin.x * scale + rect.size.width * scale / 2,
                        y: rect.origin.y * scale + rect.size.height * scale / 2)
                    .border(Color.red, width: 2)
            }
        }
    }
}
