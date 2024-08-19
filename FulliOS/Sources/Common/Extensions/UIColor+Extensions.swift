//
//  UIColor+Extensions.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 19/7/2024.
//

import Foundation

extension UIColor {
    static func random() -> UIColor {
        UIColor(
            red: .random(in: 0 ... 1),
            green: .random(in: 0 ... 1),
            blue: .random(in: 0 ... 1),
            alpha: 1.0)
    }
}
