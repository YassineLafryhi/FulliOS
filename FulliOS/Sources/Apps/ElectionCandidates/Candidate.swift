//
//  Candidate.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 21/8/2024.
//

import Foundation

internal struct Candidate: Identifiable, Codable, Equatable {
    let id: UUID
    var firstName: String
    var lastName: String
    var party: String
    var program: String

    static func empty() -> Candidate {
        Candidate(id: UUID(), firstName: "", lastName: "", party: "", program: "")
    }
}
