//
//  ExpenseAction.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

internal enum ExpenseAction {
    case getAll
    case add(Expense)
    case update(Expense)
    case delete(String)
}
