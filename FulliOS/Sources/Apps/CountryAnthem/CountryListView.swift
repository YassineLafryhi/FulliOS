//
//  CountryAnthemView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 30/8/2024.
//

import AudioKit
import SwiftUI

internal struct CountryAnthemView: View {
    @StateObject private var viewModel = CountryAnthemViewModel()

    var body: some View {
        List(viewModel.countries) { country in
            HStack {
                Text(country.flag)
                    .font(.largeTitle)
                FText(country.name)

                Spacer()

                Button(action: {
                    if viewModel.isPlaying[country.id] == true {
                        viewModel.stopAnthem(for: country)
                    } else {
                        viewModel.playAnthem(for: country)
                    }
                }) {
                    Text(viewModel.isPlaying[country.id] == true ? "Stop" : "Play")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Capsule().strokeBorder(Color.blue, lineWidth: 1))
                }
            }
            .padding()
        }
        .navigationTitle("Country Anthems")
        .onAppear {}
    }
}
