//
//  ExpensesManagerView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import SwiftData
import SwiftUI

internal struct ExpensesManagerView: View {
    @ObservedObject var store: ExpenseStore = .init()
    @State private var isShowingAddExpense = false

    var body: some View {
        NavigationView {
            VStack {
                List(store.expenses) { expense in
                    NavigationLink(destination: ExpenseDetailView(store: store, expense: expense)) {
                        VStack(alignment: .leading) {
                            Text(expense.name)
                                .font(.headline)
                            Text("\(expense.amount, specifier: "%.2f") - \(expense.category)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .navigationBarItems(trailing: Button(action: {
                isShowingAddExpense = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isShowingAddExpense) {
                AddExpenseView(store: store)
            }
            .onAppear {
                let jsonServer = GenericJsonServerWithEmbassy<Expense>(port: 9_090, apiVersion: 1, resourceName: "expenses")
                jsonServer.startServer()
                store.dispatch(action: .getAll)
            }
        }
    }
}
