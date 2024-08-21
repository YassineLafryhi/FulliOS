//
//  ElectionCandidatesView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 21/8/2024.
//

import SwiftUI

internal struct ElectionCandidatesView: View {
    @ObservedObject var store: CandidateStore = .init()

    var body: some View {
        NavigationView {
            List {
                ForEach(store.candidates) { candidate in
                    NavigationLink(destination: CandidateDetailView(store: store, candidate: candidate)) {
                        VStack(alignment: .leading) {
                            Text("\(candidate.firstName) \(candidate.lastName)")
                                .font(.headline)
                            Text(candidate.party)
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let candidate = store.candidates[index]
                        store.deleteCandidate(id: candidate.id)
                    }
                }
            }
            .navigationTitle("Candidates")
            .toolbar {
                NavigationLink(destination: AddEditCandidateView(store: store, candidate: .empty())) {
                    Text("Add")
                }
            }
        }
        .onAppear {
            store.fetchAllCandidates()
        }
    }
}
