//
//  ObjectRecognitionView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 21/7/2024.
//

import SwiftUI

internal struct ObjectRecognitionView: View {
    var body: some View {
        ObjectRecognitionViewControllerWrapper()
    }
}

internal struct ObjectRecognitionViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> VisionObjectRecognitionViewController {
        let viewController = VisionObjectRecognitionViewController()
        return viewController
    }

    func updateUIViewController(_: VisionObjectRecognitionViewController, context _: Context) {}
}
