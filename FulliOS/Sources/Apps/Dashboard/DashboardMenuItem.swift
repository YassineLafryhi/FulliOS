//
//  DashboardMenuItem.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import Foundation
import SwiftUI

internal struct DashboardMenuItem: Hashable {
    let iconName: String
    let title: String
    let testTag: String
    let destinationView: AnyView

    init(iconName: String, title: String, testTag: String = "TAG", destinationView: AnyView) {
        self.iconName = iconName
        self.title = title
        self.testTag = testTag
        self.destinationView = destinationView
    }

    static func == (lhs: DashboardMenuItem, rhs: DashboardMenuItem) -> Bool {
        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(iconName)
        hasher.combine(title)
    }
}
