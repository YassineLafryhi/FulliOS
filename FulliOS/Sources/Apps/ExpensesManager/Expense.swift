//
//  Expense.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import Foundation

internal class Expense: Codable, Identifiable {
    var id = UUID().uuidString
    var date: String
    var time: String
    var amount: Double
    var category: String
    var name: String

    init(amount: Double, category: String, name: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        let time = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.string(from: Date())
        self.date = date
        self.time = time
        self.amount = amount
        self.category = category
        self.name = name
    }
}
