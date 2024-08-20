//
//  MealSearchView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 17/8/2024.
//

import SwiftUI

internal struct MealsSearchView: View {
    @StateObject private var coordinator = MealsCoordinator()
    @StateObject private var searchViewModel = MealsSearchViewModel()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MealSearchView(viewModel: searchViewModel, coordinator: coordinator)
                .navigationDestination(for: Meal.self) { meal in
                    coordinator.build(meal)
                }
        }
    }
}
