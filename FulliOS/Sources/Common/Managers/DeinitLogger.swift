//
//  View+Extensions.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 21/7/2024.
//

import SwiftUI

internal class DeinitLogger {
    var identifier: String

    init(identifier: String) {
        self.identifier = identifier
        print("\(identifier) initialized")
    }

    deinit {
        print("\(identifier) deinitialized")
    }
}
