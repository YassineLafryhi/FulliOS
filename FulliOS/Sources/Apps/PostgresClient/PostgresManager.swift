//
//  PostgresManager.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 1/8/2024.
//

import PostgresClientKit
import SwiftUI

internal class PostgresManager: ObservableObject {
    @Published var isConnected = false
    @Published var queryResult = ""

    private var connection: Connection?

    func connect(host: String, port: Int, database: String, user: String, password: String) {
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = host
            configuration.port = port
            configuration.database = database
            configuration.user = user
            configuration.credential = .md5Password(password: password)

            connection = try PostgresClientKit.Connection(configuration: configuration)
            isConnected = true
            queryResult = "Connected successfully"
        } catch {
            isConnected = false
            queryResult = "Connection failed: \(error.localizedDescription)"
        }
    }

    func disconnect() {
        connection?.close()
        connection = nil
        isConnected = false
        queryResult = "Disconnected"
    }

    func executeQuery(_ query: String) {
        guard let connection = connection else {
            queryResult = "Not connected to database"
            return
        }

        do {
            let statement = try connection.prepareStatement(text: query)
            defer { statement.close() }

            let cursor = try statement.execute()
            defer { cursor.close() }

            var output = ""
            for row in cursor {
                let columns = try row.get().columns
                for column in columns {
                    if let value = try column.optionalString() {
                        output += value + " "
                    } else {
                        output += "NULL "
                    }
                }
                output += "\n"
            }
            queryResult = output.isEmpty ? "Query executed successfully (no results)" : output
        } catch {
            queryResult = "Query failed: \(error.localizedDescription)"
        }
    }
}
