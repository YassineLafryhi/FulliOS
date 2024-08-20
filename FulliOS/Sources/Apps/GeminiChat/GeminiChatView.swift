//
//  GeminiChatView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 19/8/2024.
//

import Foundation
import SwiftUI

internal struct GeminiChatView: View {
    @StateObject private var viewModel = GeminiChatViewModel()

    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages) { message in
                    HStack {
                        if message.isUser {
                            Spacer()
                            Text(message.text)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        } else {
                            Text(message.text)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                            Spacer()
                        }
                    }
                    .padding(message.isUser ? .trailing : .leading)
                    .padding(.vertical, 2)
                }
            }

            HStack {
                TextField("Enter message", text: $viewModel.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if viewModel.isLoading {
                    ProgressView()
                        .padding(.trailing)
                } else {
                    Button(action: viewModel.sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
            }
            .padding()
        }
    }
}
