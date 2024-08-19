//
//  LaunchesView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 1/8/2024.
//

import SwiftUI

internal struct LaunchesView: View {
    @StateObject private var viewModel = LaunchesViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.launches) { launch in
                        VStack(alignment: .leading) {
                            Text(launch.missionName)
                                .font(.headline)
                            Text("Launch Date: \(launch.launchDateUTC)")
                            Text("Rocket: \(launch.rocketName)")
                        }
                    }
                }
            }
            .navigationTitle("SpaceX Launches")
            .onAppear {
                viewModel.fetchLaunches()
            }
        }
    }
}
