import Foundation
import Vapor

final class WebSocketWrapper: @unchecked Sendable, Hashable {
    let id: UUID
    let webSocket: WebSocket

    init(webSocket: WebSocket) {
        id = UUID()
        self.webSocket = webSocket
    }

    static func == (lhs: WebSocketWrapper, rhs: WebSocketWrapper) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

actor Clients {
    var clients = Set<WebSocketWrapper>()

    func add(_ client: WebSocketWrapper) {
        clients.insert(client)
    }

    func remove(_ client: WebSocketWrapper) {
        clients.remove(client)
    }

    func broadcast(_ message: String) async {
        for client in clients {
            try? await client.webSocket.send(message)
        }
    }
}

let clients = Clients()

func sendTemperature() {
    Task.detached {
        while true {
            let temperature = String(format: "%.1f", Float.random(in: 1.0 ... 50.0))
            await clients.broadcast(temperature)
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        }
    }
}

func routes(_ app: Application) throws {
    app.get { _ async in
        "It works!"
    }

    app.get("hello") { _ async -> String in
        "Hello, world!"
    }

    app.webSocket("temperature") { _, ws in
        let wrappedSocket = WebSocketWrapper(webSocket: ws)
        Task {
            await clients.add(wrappedSocket)
            ws.onClose.whenComplete { _ in
                Task {
                    await clients.remove(wrappedSocket)
                }
            }
        }
    }
}
