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

    var body: some View {
        VStack {
            Chart(viewModel.temperatures) { data in
                LineMark(
                    x: .value("Time", data.time),
                    y: .value("Temperature", data.value))
            }
            .frame(height: 300)
            .padding()
        }
        .onAppear {
            viewModel.startObservingTemperatures()
        }
    }
}
