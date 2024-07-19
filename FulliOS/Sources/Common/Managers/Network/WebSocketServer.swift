//
//  WebSocketServer.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 11/7/2024.
//

import Foundation
import Network

internal class WebSocketServer {
    private var listener: NWListener?
    private var connections: [NWConnection] = []

    func start() {
        do {
            let parameters = NWParameters.tcp
            listener = try NWListener(using: parameters, on: 8_765)
            listener?.service = NWListener.Service(name: "TemperatureServer", type: "_temperature._tcp")

            listener?.stateUpdateHandler = { [weak self] state in
                switch state {
                case .ready:
                    print("Server is ready on 0.0.0.0:8765")
                    self?.startSendingTemperature()
                case let .failed(error):
                    print("Server failed with error: \(error)")
                    self?.listener?.cancel()
                default:
                    break
                }
            }

            listener?.newConnectionHandler = { [weak self] connection in
                self?.handleNewConnection(connection)
            }

            listener?.start(queue: .main)
        } catch {
            print("Failed to create server: \(error)")
        }
    }

    private func handleNewConnection(_ connection: NWConnection) {
        connections.append(connection)
        connection.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                print("Client connected")
            case let .failed(error), let .waiting(error):
                print("Connection error: \(error)")
                self?.removeConnection(connection)
            case .cancelled:
                print("Connection cancelled")
                self?.removeConnection(connection)
            default:
                break
            }
        }
        connection.start(queue: .main)
    }

    private func removeConnection(_ connection: NWConnection) {
        if let index = connections.firstIndex(where: { $0 === connection }) {
            connections.remove(at: index)
        }
    }

    private func startSendingTemperature() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            let temperature = String(format: "%.1f", Double.random(in: 1.0 ... 50.0))
            self?.sendToAllClients(message: temperature)
        }
    }

    private func sendToAllClients(message: String) {
        guard !connections.isEmpty else { return }
        let data = message.data(using: .utf8)!
        for connection in connections {
            connection.send(content: data, completion: .contentProcessed { error in
                if let error = error {
                    print("Failed to send data: \(error)")
                }
            })
        }
    }
}
