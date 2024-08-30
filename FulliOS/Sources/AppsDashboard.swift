//
//  DashboardView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import SwiftUI

internal struct AppsDashboard: View {
    // let persistenceController = CoreDataStack.shared

    let menuItems: [DashboardMenuItem] = [
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(menuItems.chunked(into: 2), id: \.self) { chunk in
                        HStack {
                            ForEach(chunk, id: \.title) { item in
                                FMenu(menuItem: item)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(hex: "#F8F8F8"))
            .accessibilityLabel("AppsDashboard")
            .onAppear {}
        }
    }
}

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

internal struct DashboardMenuItem: Hashable {
    let iconName: String
    let title: String
    let destinationView: AnyView

    static func == (lhs: DashboardMenuItem, rhs: DashboardMenuItem) -> Bool {
        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(iconName)
        hasher.combine(title)
    }
}
