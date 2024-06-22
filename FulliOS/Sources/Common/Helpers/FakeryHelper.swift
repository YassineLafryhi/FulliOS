//
//  FakeryHelper.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 9/6/2024.
//

import Fakery
import Foundation

internal class FakeryHelper {
    static let shared = FakeryHelper()
    private let faker = Faker()

    private init() {}

    func generateName() -> String {
        faker.name.name()
    }

    func generateEmail() -> String {
        faker.internet.email()
    }

    func generateCity() -> String {
        faker.address.city()
    }

    func generatePhoneNumber() -> String {
        faker.phoneNumber.phoneNumber()
    }
}
