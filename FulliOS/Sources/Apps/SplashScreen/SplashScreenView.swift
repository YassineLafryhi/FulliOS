//
//  SplashScreenView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import SwiftUI

internal struct SplashScreenView: View {
    @State var isActive = false

    var body: some View {
        VStack {
            if isActive {
                AppsDashboard()
            } else {
                VStack {
                    Image(R.image.logo.name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding()
                    ProgressView()
                        .scaleEffect(2)
                        .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        isActive = true
                    }
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: isActive)
    }
}
