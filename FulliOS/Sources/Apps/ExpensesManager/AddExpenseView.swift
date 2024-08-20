//
//  AddExpenseView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import SwiftData
import SwiftUI

internal struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store: ExpenseStore
    @State private var name = ""
    @State private var amount = ""
    @State private var category = ""

    var body: some View {
        Form {
            Section(header: Text("Expense Details")) {
                TextField("Name", text: $name)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Category", text: $category)
            }

            Button("Add Expense") {
                if let amountValue = Double(amount) {
                    let newExpense = Expense(amount: amountValue, category: category, name: name)
                    store.dispatch(action: .add(newExpense))
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Add Expense")
        .navigationBarTitleDisplayMode(.inline)
    }
}
