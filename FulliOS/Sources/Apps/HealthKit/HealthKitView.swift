//
//  HealthKitView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import SwiftUI

internal struct HealthKitView: View {
    @StateObject var healthKitManager = HealthKitManager()

    var body: some View {
        VStack {
            Text("HealthKit Data")
                .font(.largeTitle)
                .padding()

            HStack {
                VStack(alignment: .leading) {
                    Text("Step Count:")
                        .font(.headline)
                    Text("\(healthKitManager.stepCount)")
                        .font(.title)
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Heart Rate:")
                        .font(.headline)
                    Text(String(format: "%.1f bpm", healthKitManager.heartRate))
                        .font(.title)
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("BMI:")
                        .font(.headline)
                    Text(String(format: "%.1f", healthKitManager.bodyMassIndex))
                        .font(.title)
                }
                .padding()
            }
            .padding()

            Spacer()

            Button(action: {
                healthKitManager.requestAuthorization()
            }) {
                Text("Authorize HealthKit")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .onAppear {
            healthKitManager.requestAuthorization()
        }
    }
}
