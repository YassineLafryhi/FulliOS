//
//  Meal.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 17/8/2024.
//

import Foundation

internal struct Meal: Identifiable, Decodable, Hashable {
    let id: String
    let name: String
    let category: String
    let area: String
    let instructions: String
    let thumbURL: URL
    let ingredients: [String]
    let measures: [String]

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumbURL = "strMealThumb"
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5
        case strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10
        case strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        case strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(String.self, forKey: .category)
        area = try container.decode(String.self, forKey: .area)
        instructions = try container.decode(String.self, forKey: .instructions)
        thumbURL = try container.decode(URL.self, forKey: .thumbURL)

        ingredients = (1 ... 20).compactMap { index in
            let key = CodingKeys(rawValue: "strIngredient\(index)")!
            return try? container.decode(String.self, forKey: key)
        }.filter { !$0.isEmpty }

        measures = (1 ... 20).compactMap { index in
            let key = CodingKeys(rawValue: "strMeasure\(index)")!
            return try? container.decode(String.self, forKey: key)
        }.filter { !$0.isEmpty }
    }
}

internal struct MealResponse: Decodable {
    let meals: [Meal]?
}
