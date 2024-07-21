//
//  NewsContentView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 15/7/2024.
//

import SwiftUI

internal struct NewsView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NewsViewControllerWrapper(showAlert: $showAlert, alertMessage: $alertMessage)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
    }
}

internal struct NewsViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var showAlert: Bool
    @Binding var alertMessage: String

    func makeUIViewController(context _: Context) -> NewsViewController {
        let viewController = NewsRouter().createModule() as! NewsViewController
        return viewController
    }

    func updateUIViewController(_: NewsViewController, context _: Context) {}
}
