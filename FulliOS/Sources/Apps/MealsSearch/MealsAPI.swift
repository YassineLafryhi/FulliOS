//
//  MealsAPI.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 17/8/2024.
//

import Moya

enum MealsAPI {
    case searchMeals(query: String)
}

extension MealsAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://www.themealdb.com/api/json/v1/1")!
    }

    var path: String {
        switch self {
        case .searchMeals:
            return "/search.php"
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        switch self {
        case let .searchMeals(query):
            return .requestParameters(parameters: ["f": query], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
