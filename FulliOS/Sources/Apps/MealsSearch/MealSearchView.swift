//
//  MealSearchView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 17/8/2024.
//

import SwiftUI

internal struct MealSearchView: View {
    @ObservedObject var viewModel: MealsSearchViewModel
    let coordinator: MealsCoordinator

    var body: some View {
        NavigationView {
            VStack {
                MealSearchBar(text: $viewModel.searchQuery, onSearch: viewModel.searchMeals)

                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.meals) { meal in
                        Button(action: {
                            coordinator.showMealDetail(meal: meal)
                        }) {
                            Text(meal.name)
                        }
                    }
                }
            }
            .navigationTitle("Meal Search")
        }
    }
}

internal struct MealSearchBar: View {
    @Binding var text: String
    let onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search meals", text: $text, onCommit: onSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
            }
        }
        .padding()
    }
}
