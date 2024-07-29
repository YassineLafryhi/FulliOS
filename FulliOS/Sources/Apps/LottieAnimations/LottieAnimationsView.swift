//
//  LottieAnimationsView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import Lottie
import SwiftUI

internal struct MyLottieAnimationView: UIViewRepresentable {
    var animationName: String

    func makeUIView(context _: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        return animationView
    }

    func updateUIView(_: LottieAnimationView, context _: Context) {}
}

internal struct LottieAnimationsGridView: View {
    let animationNames: [String] = ["loader", "error", "success", "warning", "working", "happy", "sad"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(animationNames, id: \.self) { animationName in
                    GeometryReader { geometry in
                        MyLottieAnimationView(animationName: animationName)
                            .frame(width: geometry.size.width, height: geometry.size.width)
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: UIScreen.main.bounds.width - 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

internal struct LottieAnimationsView: View {
    var body: some View {
        LottieAnimationsGridView()
    }
}
