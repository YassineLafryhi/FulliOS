//
//  MealDetailView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 17/8/2024.
//

import SwiftUI

internal struct MealDetailView: View {
    @ObservedObject var viewModel: MealDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: viewModel.meal.thumbURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }

                Text(viewModel.meal.name)
                    .font(.title)

                Text("Category: \(viewModel.meal.category)")
                Text("Area: \(viewModel.meal.area)")

                Text("Ingredients:")
                    .font(.headline)
                ForEach(Array(zip(viewModel.meal.ingredients, viewModel.meal.measures)), id: \.0) { ingredient, measure in
                    Text("• \(measure) \(ingredient)")
                }

                Text("Instructions:")
                    .font(.headline)
                Text(viewModel.meal.instructions)
            }
            .padding()
        }
        .navigationTitle("Meal Detail")
    }
}
