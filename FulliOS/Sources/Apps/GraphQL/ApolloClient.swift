//
//  ApolloClient.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 1/8/2024.
//

import Apollo

internal class Network {
    static let shared = Network()
    private(set) lazy var apollo = ApolloClient(url: URL(string: "https://api.spacex.land/graphql/")!)
}
