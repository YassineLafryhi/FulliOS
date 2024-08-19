//
//  PostgresClientView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 1/8/2024.
//

import SwiftUI

internal struct PostgresClientView: View {
    @StateObject private var postgresManager = PostgresManager()
    @State private var host = "localhost"
    @State private var port = "5432"
    @State private var database = "mydb"
    @State private var user = "postgres"
    @State private var password = ""
    @State private var query = "SELECT * FROM mytable LIMIT 5;"

    var body: some View {
        VStack {
            Group {
                TextField("Host", text: $host)
                TextField("Port", text: $port)
                TextField("Database", text: $database)
                TextField("User", text: $user)
                SecureField("Password", text: $password)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)

            HStack {
                Button(postgresManager.isConnected ? "Disconnect" : "Connect") {
                    if postgresManager.isConnected {
                        postgresManager.disconnect()
                    } else {
                        postgresManager.connect(
                            host: host,
                            port: Int(port) ?? 5_432,
                            database: database,
                            user: user,
                            password: password)
                    }
                }
                .disabled(host.isEmpty || port.isEmpty || database.isEmpty || user.isEmpty)

                Button("Execute Query") {
                    postgresManager.executeQuery(query)
                }
                .disabled(!postgresManager.isConnected)
            }
            .padding()

            TextEditor(text: $query)
                .border(Color.gray, width: 1)
                .padding()

            ScrollView {
                Text(postgresManager.queryResult)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .border(Color.gray, width: 1)
        }
    }
}
