//
//  CandidateDetailView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 21/8/2024.
//

import SwiftUI

internal struct CandidateDetailView: View {
    @ObservedObject var store: CandidateStore
    var candidate: Candidate

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(candidate.firstName) \(candidate.lastName)")
                .font(.largeTitle)

            Text("Party: \(candidate.party)")
                .font(.title2)

            Text("Program:")
                .font(.title2)

            Text(candidate.program)
                .font(.body)

            NavigationLink(destination: AddEditCandidateView(store: store, candidate: candidate)) {
                Text("Edit")
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .navigationTitle("Candidate Details")
    }
}
