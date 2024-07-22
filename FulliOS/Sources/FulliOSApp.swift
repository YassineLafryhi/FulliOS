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
    let flutterEngine = FlutterEngine(name: "MyFlutterEngine")

    init() {
        flutterEngine.run()
        // GeneratedPluginRegistrant.register(with: flutterEngine)

        let server = WebSocketServer()
        server.start()
    }
}

@main
internal struct FulliOS: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var flutterDependencies = FlutterDependencies()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(flutterDependencies)
        }.modelContainer(SharedModelContainer.sharedModelContainer)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        true
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        UnityBridge.shared.unityFramework?.appController().application(application, handleOpen: url) ?? false
    }

    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
        .all
    }
}
