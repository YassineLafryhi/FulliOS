//
//  MealsAPIService.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 17/8/2024.
//

import Foundation
import Moya

internal class MealsAPIService {
    private let provider = MoyaProvider<MealsAPI>()

    func searchMeals(query: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        provider.request(.searchMeals(query: query)) { result in
            switch result {
            case let .success(response):
                do {
                    let mealResponse = try JSONDecoder().decode(MealResponse.self, from: response.data)
                    completion(.success(mealResponse.meals ?? []))
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
