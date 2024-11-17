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
import UnityFramework

internal class FlutterDependencies: ObservableObject {
    private let networkManager = NetworkManager.shared
    let flutterEngine = FlutterEngine(name: "MyFlutterEngine")

    init() {
        CrashHandler.shared.setupCrashHandler()
        _ = networkManager
        flutterEngine.run()
        // GeneratedPluginRegistrant.register(with: flutterEngine)
        let server = WebSocketServer()
        server.start()
    }
}

@main
internal struct FulliOS: App {
    @StateObject var flutterDependencies = FlutterDependencies()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(flutterDependencies)
                .onAppear {
                    UnityBridge.shared.initializeUnity()
                }
        }.modelContainer(SharedModelContainer.sharedModelContainer)
    }
}
