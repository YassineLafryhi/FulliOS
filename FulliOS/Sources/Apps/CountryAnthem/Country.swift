//
//  Country.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 30/8/2024.
//

import Foundation

internal struct Country: Identifiable {
    let id = UUID()
    let name: String
    let flag: String
    let anthemFileName: String
}
