//
//  MealDetailViewModel.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 17/8/2024.
//

import Foundation

internal class MealDetailViewModel: ObservableObject {
    @Published var meal: Meal

    init(meal: Meal) {
        self.meal = meal
    }
}
