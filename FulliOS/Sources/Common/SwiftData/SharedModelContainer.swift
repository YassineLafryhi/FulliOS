//
//  SharedModelContainer.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import Foundation
import SwiftData

internal class SharedModelContainer {
    public static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ContactItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
