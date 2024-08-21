//
//  AddEditCandidateView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 21/8/2024.
//

import SwiftUI

internal struct AddEditCandidateView: View {
    @ObservedObject var store: CandidateStore
    @Environment(\.presentationMode) var presentationMode
    @State var candidate: Candidate

    var isEditing: Bool {
        candidate.id != UUID()
    }

    var body: some View {
        Form {
            Section(header: Text("Personal Info")) {
                TextField("First Name", text: $candidate.firstName)
                TextField("Last Name", text: $candidate.lastName)
            }

            Section(header: Text("Party")) {
                TextField("Party", text: $candidate.party)
            }

            Section(header: Text("Program")) {
                TextField("Program", text: $candidate.program)
            }
        }
        .navigationTitle(isEditing ? "Edit Candidate" : "Add Candidate")
        .toolbar {
            Button("Save") {
                if isEditing {
                    store.createCandidate(candidate: candidate)
                } else {
                    store.createCandidate(candidate: candidate)
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
