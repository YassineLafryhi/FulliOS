//
//  MealsSearchViewModel.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 17/8/2024.
//

import Foundation

internal class MealsSearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiService: MealsAPIService

    init(apiService: MealsAPIService = MealsAPIService()) {
        self.apiService = apiService
    }

    func searchMeals() {
        guard !searchQuery.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        apiService.searchMeals(query: searchQuery) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case let .success(meals):
                    self?.meals = meals
                case let .failure(error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
