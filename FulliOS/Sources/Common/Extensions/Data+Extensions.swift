//
//  Data+Extensions.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import Alamofire
import Foundation

extension Data {
    func toParameters() -> Parameters? {
        try? JSONSerialization.jsonObject(with: self, options: []) as? Parameters
    }
}
