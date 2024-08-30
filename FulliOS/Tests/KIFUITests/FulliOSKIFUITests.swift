//
//  FulliOSKIFUITests.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 30/8/2024.
//

import KIF
import XCTest

internal final class FulliOSKIFUITests: KIFTestCase {
    func testAppLaunches() {
        tester().waitForAnimationsToFinish()
        tester().waitForView(withAccessibilityLabel: "AppsDashboard")
    }
}
