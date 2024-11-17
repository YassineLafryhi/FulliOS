//
//  ContactItem.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import Foundation
import SwiftData

@Model
internal class ContactItem {
    @Attribute(.unique) let id = UUID()
    let name: String
    let email: String
    let city: String

    init(name: String, email: String, city: String) {
        self.name = name
        self.email = email
        self.city = city
    }
}
