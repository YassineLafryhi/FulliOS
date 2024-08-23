//
//  FulliOSApp.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import SwiftData
import SwiftUI

internal class AppDependencies: ObservableObject {
    init() {
        CrashHandler.shared.setupCrashHandler()
        let server = WebSocketServer()
        server.start()
    }
}

@main
internal struct FulliOS: App {
    @StateObject var appDependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(appDependencies)
                .onAppear {}
        }.modelContainer(SharedModelContainer.sharedModelContainer)
    }
}
