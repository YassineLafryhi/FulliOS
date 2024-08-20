//
//  ExpenseStatisticsView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import SwiftUI

internal struct ExpenseStatisticsView: View {
    @ObservedObject var store: ExpenseStore

    var body: some View {
        VStack {
            Text("Total Expenses: \(totalExpenses, specifier: "%.2f")")
            // TODO: Add more statistics here
        }
        .padding()
        .navigationTitle("Statistics")
    }

    private var totalExpenses: Double {
        store.expenses.reduce(0) { $0 + $1.amount }
    }
}
