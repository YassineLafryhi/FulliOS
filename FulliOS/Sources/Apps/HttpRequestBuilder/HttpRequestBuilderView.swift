//
//  HttpRequestBuilderView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/7/2024.
//

import SwiftUI

internal struct HttpRequestBuilderView: View {
    @ObservedObject var viewModel = HttpRequestViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Picker("Request Type", selection: $viewModel.requestData.requestType) {
                    ForEach(viewModel.requestTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TextField("URL", text: $viewModel.requestData.url)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Query Parameters (key=value&key=value)", text: $viewModel.requestData.queryParams)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Request Body (JSON)", text: $viewModel.requestData.requestBody)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Headers (key=value;key=value)", text: $viewModel.requestData.headers)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: viewModel.sendRequest) {
                    Text("Send Request")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                ScrollView {
                    Text(viewModel.responseText)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()

                Spacer()
            }
            .navigationTitle("HTTP Request Builder")
        }
    }
}
