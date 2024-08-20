//
//  ExpenseDetailView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import SwiftUI

internal struct ExpenseDetailView: View {
    @ObservedObject var store: ExpenseStore
    @State var expense: Expense

    var body: some View {
        Form {
            TextField("Time", text: $expense.time)
            TextField("Date", text: $expense.date)
            TextField("Amount", value: $expense.amount, format: .currency(code: "USD"))
            TextField("Category", text: $expense.category)
            TextField("Name", text: $expense.name)

            Button("Save") {
                store.dispatch(action: .update(expense))
            }

            Button("Delete") {
                store.dispatch(action: .delete(expense.id))
            }
            .foregroundColor(.red)
        }
        .navigationTitle("Edit Expense")
    }
}
