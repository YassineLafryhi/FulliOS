//
//  ExpenseStore.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import Combine
import SwiftData
import SwiftUI

internal class ExpenseStore: ObservableObject {
    @Published var expenses: [Expense] = []
    private var cancellables = Set<AnyCancellable>()
    private var expenseAPI = ExpensesAPI()

    func dispatch(action: ExpenseAction) {
        switch action {
        case .getAll:
            fetchAllExpenses()
        case let .add(expense):
            addExpense(expense)
        case let .update(expense):
            updateExpense(expense)
        case let .delete(id):
            deleteExpense(id: id)
        }
    }

    private func fetchAllExpenses() {
        expenseAPI.getAllExpenses { result in
            switch result {
            case let .success(expenses):
                self.expenses = expenses
            case let .failure(error):
                Logger.shared.log("Error: \(error)")
            }
        }
    }

    private func addExpense(_ expense: Expense) {
        expenseAPI.addExpense(expense) { result in
            switch result {
            case let .success(expense):
                self.fetchAllExpenses()
            case let .failure(error):
                Logger.shared.log("Error: \(error)")
            }
        }
    }

    private func updateExpense(_ expense: Expense) {
        expenseAPI.updateExpense(expense) { result in
            switch result {
            case let .success(expense):
                self.fetchAllExpenses()
            case let .failure(error):
                Logger.shared.log("Error: \(error)")
            }
        }
    }

    private func deleteExpense(id: String) {
        expenseAPI.deleteExpense(id: id) { result in
            switch result {
            case .success:
                self.fetchAllExpenses()
            case let .failure(error):
                Logger.shared.log("Error: \(error)")
            }
        }
    }
}
