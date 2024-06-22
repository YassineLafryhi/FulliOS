//
//  ContentView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import SwiftData
import SwiftUI

internal struct SwiftDataContactsView: View {
    @Environment(\.modelContext)
    private var modelContext
    @Query
    private var dataModel: [ContactItem]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                FButton("Add New Contact", type: .success) {
                    let contact = ContactItem(
                        name: FakeryHelper.shared.generateName(),
                        email: FakeryHelper.shared.generateEmail(),
                        city: FakeryHelper.shared.generateCity())

                    modelContext.insert(contact)
                }
            }
            List(dataModel) { item in
                ContactRow(contact: item) {
                    modelContext.delete(item)
                }
            }
        }
        .padding()
    }
}
