//
//  ExpensesAPI.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import Alamofire

internal class ExpensesAPI {
    private let baseURL = "http://localhost:9090/api/v1/expenses"

    func getAllExpenses(completion: @escaping (Result<[Expense], AFError>) -> Void) {
        AF.request(baseURL, method: .get)
            .validate()
            .responseDecodable(of: [Expense].self) { response in
                completion(response.result)
            }
    }

    func addExpense(_ expense: Expense, completion: @escaping (Result<Expense, AFError>) -> Void) {
        let parameters = try? JSONEncoder().encode(expense).toParameters()
        AF.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: Expense.self) { response in
                completion(response.result)
            }
    }

    func updateExpense(_ expense: Expense, completion: @escaping (Result<Expense, AFError>) -> Void) {
        let id = expense.id
        let url = "\(baseURL)/\(id)"
        let parameters = try? JSONEncoder().encode(expense).toParameters()
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: Expense.self) { response in
                completion(response.result)
            }
    }

    func deleteExpense(id: String, completion: @escaping (Result<Void, AFError>) -> Void) {
        let url = "\(baseURL)/\(id)"
        AF.request(url, method: .delete)
            .validate()
            .response { response in
                completion(response.result.map { _ in })
            }
    }
}
