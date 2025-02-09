//
//  Array+Extensions.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
