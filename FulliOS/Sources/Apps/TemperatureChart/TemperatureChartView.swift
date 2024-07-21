//
//  TemperatureChartView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 11/7/2024.
//

import Charts
import SwiftUI

internal struct TemperatureChartView: View {
    @StateObject private var viewModel = TemperatureViewModel()
    @State private var wsUrl = Constants.TemperatureChartApp.wsUrl

    var body: some View {
        VStack {
            TextField("WebSocket URL", text: $wsUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Start Connection") {
                viewModel.startObservingTemperatures(url: wsUrl)
            }
            .padding()

            Chart(viewModel.temperatures) { data in
                LineMark(
                    x: .value("Time", data.time),
                    y: .value("Temperature", data.value))
            }
            .frame(height: 300)
            .padding()
        }
    }
}
