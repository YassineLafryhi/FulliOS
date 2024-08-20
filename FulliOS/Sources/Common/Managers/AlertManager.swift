//
//  AlertManager.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import SwiftUI

internal class AlertManager: ObservableObject {
    static let shared = AlertManager()

    @Published var isPresented = false
    @Published var alertData: AlertData?

    private init() {}

    struct AlertData: Identifiable {
        let id = UUID()
        let title: String
        let message: String
        let dismissAction: () -> Void
    }

    func showAlert(title: String, message: String, dismissAction: @escaping () -> Void = {}) {
        alertData = AlertData(title: title, message: message, dismissAction: dismissAction)
        withAnimation(.easeInOut(duration: 0.3)) {
            isPresented = true
        }
    }

    func hideAlert() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isPresented = false
        }
    }
}

internal struct CustomAlertView: View {
    @ObservedObject private var alertManager = AlertManager.shared

    var body: some View {
        if let alertData = alertManager.alertData {
            VStack {
                Spacer()
                VStack(spacing: 20) {
                    Text(alertData.title)
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    Text(alertData.message)
                        .font(.body)
                        .multilineTextAlignment(.center)

                    Button("OK") {
                        alertData.dismissAction()
                        alertManager.hideAlert()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.4))
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
        }
    }
}

internal struct AlertModifier: ViewModifier {
    @ObservedObject private var alertManager = AlertManager.shared

    func body(content: Content) -> some View {
        ZStack {
            content
            if alertManager.isPresented {
                CustomAlertView()
            }
        }
    }
}

extension View {
    func withAlert() -> some View {
        modifier(AlertModifier())
    }
}
