//
//  FlutterView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 6/6/2024.
//

import Flutter
import SwiftUI

internal struct FlutterView: View {
    @EnvironmentObject var flutterDependencies: FlutterDependencies

    var body: some View {
        VStack {}.onAppear {
            openFlutterApp()
        }
    }

    func openFlutterApp() {
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
            let window = windowScene.windows.first(where: \.isKeyWindow),
            let rootViewController = window.rootViewController
        else { return }

        let flutterViewController = FlutterViewController(
            engine: flutterDependencies.flutterEngine,
            nibName: nil,
            bundle: nil)
        flutterViewController.modalPresentationStyle = .overCurrentContext
        flutterViewController.isViewOpaque = false

        rootViewController.present(flutterViewController, animated: true)
    }
}
