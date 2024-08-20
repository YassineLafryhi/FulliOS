//
//  MealsCoordinator.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 17/8/2024.
//

import SwiftUI

internal class MealsCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    func showMealDetail(meal: Meal) {
        path.append(meal)
    }

    @ViewBuilder
    func build(_ meal: Meal) -> some View {
        MealDetailView(viewModel: MealDetailViewModel(meal: meal))
    }
}
