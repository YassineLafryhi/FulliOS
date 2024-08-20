//
//  GenericJsonServer.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import Foundation
import GCDWebServer

internal class GenericJsonServer<T: Codable> {
    let port: Int
    let apiVersion: Int
    let resourceName: String
    private var webServer: GCDWebServer
    private var items: [T] = []

    init(port: Int, apiVersion: Int, resourceName: String) {
        self.port = port
        self.apiVersion = apiVersion
        self.resourceName = resourceName
        webServer = GCDWebServer()
        setupRoutes()
    }

    private func setupRoutes() {
        webServer
            .addHandler(
                forMethod: "GET",
                path: "/api/v\(apiVersion)/\(resourceName)",
                request: GCDWebServerRequest.self) { [weak self] _ in
            self?.createJsonResponse(data: self?.items ?? [])
            }

        webServer.addHandler(
            forMethod: "GET",
            pathRegex: "/api/v\(apiVersion)/\(resourceName)/([0-9]+)",
            request: GCDWebServerRequest.self) { [weak self] request in
            guard
                let match = request.url.path.range(
                    of: "/api/v\\d+/\(self?.resourceName ?? "")/(\\d+)",
                    options: .regularExpression),
                let indexString = request.url.path[match].components(separatedBy: "/").last,
                let index = Int(indexString), index < self?.items.count ?? 0 else {
                return GCDWebServerDataResponse(statusCode: 404)
            }
            return self?.createJsonResponse(data: self?.items[index])
        }

        webServer.addHandler(
            forMethod: "POST",
            path: "/api/v\(apiVersion)/\(resourceName)",
            request: GCDWebServerDataRequest.self) { [weak self] request in
            guard
                let requestData = (request as? GCDWebServerDataRequest)?.data,
                !requestData.isEmpty else {
                print("Request data is nil or empty.")
                return GCDWebServerDataResponse(statusCode: 400)
            }

            do {
                let newItem = try JSONDecoder().decode(T.self, from: requestData)
                self?.items.append(newItem)
                return GCDWebServerDataResponse(statusCode: 201)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                return GCDWebServerDataResponse(statusCode: 400)
            }
        }

        webServer.addHandler(
            forMethod: "PUT",
            pathRegex: "/api/v\(apiVersion)/\(resourceName)/([0-9]+)",
            request: GCDWebServerDataRequest.self) { [weak self] request in
            guard
                let match = request.url.path.range(
                    of: "/api/v\\d+/\(self?.resourceName ?? "")/(\\d+)",
                    options: .regularExpression),
                let indexString = request.url.path[match].components(separatedBy: "/").last,
                let index = Int(indexString), index < self?.items.count ?? 0,
                let requestData = (request as? GCDWebServerDataRequest)?.data,
                let updatedItem = try? JSONDecoder().decode(T.self, from: requestData) else {
                return GCDWebServerDataResponse(statusCode: 400)
            }
            self?.items[index] = updatedItem
            return GCDWebServerDataResponse(statusCode: 200)
        }

        webServer.addHandler(
            forMethod: "PATCH",
            pathRegex: "/api/v\(apiVersion)/\(resourceName)/([0-9]+)",
            request: GCDWebServerDataRequest.self) { [weak self] request in
            guard
                let match = request.url.path.range(
                    of: "/api/v\\d+/\(self?.resourceName ?? "")/(\\d+)",
                    options: .regularExpression),
                let indexString = request.url.path[match].components(separatedBy: "/").last,
                let index = Int(indexString), index < self?.items.count ?? 0,
                var existingItem = try? JSONDecoder().decode(T.self, from: JSONEncoder().encode(self?.items[index])) else {
                return GCDWebServerDataResponse(statusCode: 400)
            }
            // TODO: Merge `existingItem` and `newData` here.
            let newItem = try? JSONDecoder().decode(T.self, from: (request as? GCDWebServerDataRequest)?.data ?? Data())
            existingItem = newItem ?? existingItem
            self?.items[index] = existingItem
            return GCDWebServerDataResponse(statusCode: 200)
        }

        webServer.addHandler(
            forMethod: "DELETE",
            pathRegex: "/api/v\(apiVersion)/\(resourceName)/([0-9]+)",
            request: GCDWebServerRequest.self) { [weak self] request in
            guard
                let match = request.url.path.range(
                    of: "/api/v\\d+/\(self?.resourceName ?? "")/(\\d+)",
                    options: .regularExpression),
                let indexString = request.url.path[match].components(separatedBy: "/").last,
                let index = Int(indexString), index < self?.items.count ?? 0 else {
                return GCDWebServerDataResponse(statusCode: 404)
            }
            self?.items.remove(at: index)
            return GCDWebServerDataResponse(statusCode: 204)
        }
    }

    private func createJsonResponse<DataType: Codable>(data: DataType?) -> GCDWebServerDataResponse? {
        guard let data = data else {
            return GCDWebServerDataResponse(statusCode: 404)
        }
        do {
            let jsonData = try JSONEncoder().encode(data)
            return GCDWebServerDataResponse(data: jsonData, contentType: "application/json")
        } catch {
            print("Error creating JSON response: \(error)")
            return GCDWebServerDataResponse(statusCode: 500)
        }
    }

    func startServer() {
        webServer.start(withPort: UInt(port), bonjourName: "Generic JSON Server")
        print("Generic JSON Server started at \(webServer.serverURL?.absoluteString ?? "http://localhost:\(port)")")
    }
}
