//
//  UnityGameView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 22/7/2024.
//

import SwiftUI

struct UnityGameView: View {
    @State private var showUnityView = false

    var body: some View {
        VStack {
            Button("Open Unity Game") {
                showUnityView = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .fullScreenCover(isPresented: $showUnityView) {
            UnityViewControllerRepresentable()
        }
    }
}

struct UnityViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> UIViewController {
        let unityViewController = UIViewController()
        UnityBridge.shared.show(in: unityViewController)
        return unityViewController
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}
}
