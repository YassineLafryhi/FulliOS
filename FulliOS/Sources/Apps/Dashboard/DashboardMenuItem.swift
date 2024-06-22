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
    let destinationView: AnyView

    static func == (lhs: DashboardMenuItem, rhs: DashboardMenuItem) -> Bool {
        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(iconName)
        hasher.combine(title)
    }
}
