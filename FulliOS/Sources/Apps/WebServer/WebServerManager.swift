//
//  WebServerManager.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 27/7/2024.
//

import Foundation
import GCDWebServer

internal class WebServerManager {
    static let shared = WebServerManager()
    private var webServer: GCDWebServer

    private init() {
        webServer = GCDWebServer()
        setupRoutes()
    }

    private func setupRoutes() {
        webServer.addHandler(forMethod: "GET", path: "/hello", request: GCDWebServerRequest.self) { [weak self] _ in
            GCDWebServerDataResponse(text: "Handling GET request")
        }

        webServer
            .addHandler(forMethod: "POST", path: "/data", request: GCDWebServerDataRequest.self) { [weak self] _ in
                GCDWebServerDataResponse(text: "Handling POST request")
            }
    }

    func startServer() {
        webServer.start(withPort: 8_080, bonjourName: "Web Server")
        Logger.shared.log("Web Server started at \(webServer.serverURL ?? URL(string: "http://localhost:8080")!)")
    }
}
