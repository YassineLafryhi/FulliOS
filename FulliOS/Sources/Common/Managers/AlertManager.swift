//
//  AlertManager.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import SwiftUI

internal final class AlertManager: ObservableObject {
    static let shared = AlertManager()

    @Published var alert: AlertData?

    private init() {}

    struct AlertData: Identifiable {
        var id = UUID()
        let title: String
        let message: String
        let dismissButton: Alert.Button
    }

    func showAlert(title: String, message: String, dismissButton: Alert.Button = .default(Text("OK"))) {
        alert = AlertData(title: title, message: message, dismissButton: dismissButton)
    }

    func hideAlert() {
        alert = nil
    }
}
