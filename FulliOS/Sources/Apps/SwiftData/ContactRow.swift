//
//  ContactRow.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 9/6/2024.
//

import SwiftUI

internal struct ContactRow: View {
    var contact: ContactItem
    var onDelete: () -> Void

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://thispersondoesnotexist.com")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case let .success(image):
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                case .failure:
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 50, height: 50)

            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.system(size: 18, weight: .medium))
                Text(contact.email)
                    .font(.system(size: 16))
                Text(contact.city)
                    .font(.system(size: 14))
            }
            .padding(.leading, 10)

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
    }
}
