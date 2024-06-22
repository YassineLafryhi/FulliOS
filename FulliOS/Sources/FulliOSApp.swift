//
//  FulliOSApp.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import Flutter
// import FlutterPluginRegistrant
import SwiftData
import SwiftUI

internal class FlutterDependencies: ObservableObject {
    let flutterEngine = FlutterEngine(name: "MyFlutterEngine")

    init() {
        flutterEngine.run()
        // GeneratedPluginRegistrant.register(with: flutterEngine)
    }
}

@main
internal struct FulliOS: App {
    @StateObject var flutterDependencies = FlutterDependencies()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(flutterDependencies)
        }.modelContainer(SharedModelContainer.sharedModelContainer)
    }
}
