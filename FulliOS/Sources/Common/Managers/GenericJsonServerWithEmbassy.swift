//
//  GenericJsonServerWithEmbassy.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import Embassy
import Foundation

internal class GenericJsonServerWithEmbassy<T: Codable> {
    let port: Int
    let apiVersion: Int
    let resourceName: String
    private var items: [T] = []
    private let serverQueue = DispatchQueue(label: "GenericJsonServerWithEmbassyQueue", qos: .background)

    private var server: HTTPServer?
    private let loop: EventLoop

    init(port: Int, apiVersion: Int, resourceName: String) {
        self.port = port
        self.apiVersion = apiVersion
        self.resourceName = resourceName

        loop = try! SelectorEventLoop(selector: try! KqueueSelector())
        server = DefaultHTTPServer(eventLoop: loop, interface: "::", port: port) { [weak self] environ, startResponse, sendBody in
            self?.handleRequest(environ: environ, startResponse: startResponse, sendBody: sendBody)
        }
    }

    private func handleRequest(
        environ: [String: Any],
        startResponse: @escaping (String, [(String, String)]) -> Void,
        sendBody: @escaping (Data) -> Void) {
        guard
            let method = environ["REQUEST_METHOD"] as? String,
            let path = environ["PATH_INFO"] as? String else {
            startResponse("400 Bad Request", [])
            sendBody(Data())
            return
        }

        switch method {
        case "GET":
            handleGetRequest(path: path, startResponse: startResponse, sendBody: sendBody)
        case "POST":
            handlePostRequest(environ: environ, startResponse: startResponse, sendBody: sendBody)
        case "PUT":
            handlePutRequest(path: path, environ: environ, startResponse: startResponse, sendBody: sendBody)
        case "PATCH":
            handlePatchRequest(path: path, environ: environ, startResponse: startResponse, sendBody: sendBody)
        case "DELETE":
            handleDeleteRequest(path: path, startResponse: startResponse, sendBody: sendBody)
        default:
            startResponse("405 Method Not Allowed", [])
            sendBody(Data())
        }
    }

    private func handleGetRequest(
        path: String,
        startResponse: @escaping (String, [(String, String)]) -> Void,
        sendBody: @escaping (Data) -> Void) {
        if path == "/api/v\(apiVersion)/\(resourceName)" {
            let response = createJsonResponse(data: items)
            startResponse("200 OK", [("Content-Type", "application/json")])
            sendBody(response)
        } else if let id = extractId(from: path), id < items.count {
            let response = createJsonResponse(data: items[id])
            startResponse("200 OK", [("Content-Type", "application/json")])
            sendBody(response)
        } else {
            startResponse("404 Not Found", [])
            sendBody(Data())
        }
    }

    private func handlePostRequest(
        environ: [String: Any],
        startResponse: @escaping (String, [(String, String)]) -> Void,
        sendBody: @escaping (Data) -> Void) {
        let input = environ["swsgi.input"] as! SWSGIInput
        input { [weak self] data in
            do {
                let newItem = try JSONDecoder().decode(T.self, from: data)
                self?.items.append(newItem)
                startResponse("201 Created", [])
                sendBody(Data())
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                startResponse("400 Bad Request", [])
                sendBody(Data())
            }
        }
    }

    private func handlePutRequest(
        path: String,
        environ: [String: Any],
        startResponse: @escaping (String, [(String, String)]) -> Void,
        sendBody: @escaping (Data) -> Void) {
        if let id = extractId(from: path), id < items.count {
            let input = environ["swsgi.input"] as! SWSGIInput
            input { [weak self] data in
                do {
                    let updatedItem = try JSONDecoder().decode(T.self, from: data)
                    self?.items[id] = updatedItem
                    startResponse("200 OK", [])
                    sendBody(Data())
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    startResponse("400 Bad Request", [])
                    sendBody(Data())
                }
            }
        } else {
            startResponse("404 Not Found", [])
            sendBody(Data())
        }
    }

    private func handlePatchRequest(
        path: String,
        environ: [String: Any],
        startResponse: @escaping (String, [(String, String)]) -> Void,
        sendBody: @escaping (Data) -> Void) {
        if let id = extractId(from: path), id < items.count {
            let input = environ["swsgi.input"] as! SWSGIInput
            input { [weak self] data in
                do {
                    // Example patch logic, adjust as needed
                    var existingItem = self?.items[id]
                    let patchData = try JSONDecoder().decode(T.self, from: data)
                    existingItem = patchData // Simplified example
                    self?.items[id] = existingItem!
                    startResponse("200 OK", [])
                    sendBody(Data())
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    startResponse("400 Bad Request", [])
                    sendBody(Data())
                }
            }
        } else {
            startResponse("404 Not Found", [])
            sendBody(Data())
        }
    }

    private func handleDeleteRequest(
        path: String,
        startResponse: @escaping (String, [(String, String)]) -> Void,
        sendBody: @escaping (Data) -> Void) {
        if let id = extractId(from: path), id < items.count {
            items.remove(at: id)
            startResponse("204 No Content", [])
            sendBody(Data())
        } else {
            startResponse("404 Not Found", [])
            sendBody(Data())
        }
    }

    private func createJsonResponse<DataType: Codable>(data: DataType?) -> Data {
        guard let data = data else {
            return Data()
        }
        do {
            return try JSONEncoder().encode(data)
        } catch {
            print("Error creating JSON response: \(error.localizedDescription)")
            return Data()
        }
    }

    private func extractId(from path: String) -> Int? {
        let pattern = "/api/v\\d+/\(resourceName)/(\\d+)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: path.utf16.count)
        if
            let match = regex?.firstMatch(in: path, options: [], range: range),
            let idRange = Range(match.range(at: 1), in: path) {
            return Int(path[idRange])
        }
        return nil
    }

    func startServer() {
        serverQueue.async {
            do {
                try self.server?.start()
                print("Generic JSON Server started at http://localhost:\(self.port)")
                self.loop.runForever()
            } catch {
                print("Failed to start server: \(error.localizedDescription)")
            }
        }
    }
}
