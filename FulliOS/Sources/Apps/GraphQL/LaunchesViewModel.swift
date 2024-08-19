//
//  LaunchesViewModel.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 1/8/2024.
//

import Apollo
import SwiftUI

internal class LaunchesViewModel: ObservableObject {
    @Published var launches: [Launch] = []
    @Published var isLoading = false

    func fetchLaunches() {
        isLoading = true
        /* Network.shared.apollo.fetch(query: LaunchesQuery()) { result in
             self.isLoading = false
             switch result {
             case .success(let graphQLResult):
                 if let launchesData = graphQLResult.data?.launchesPast {
                     self.launches = launchesData.compactMap { $0?.asLaunch }
                 }
             case .failure(let error):
                 print("Error loading launches: \(error.localizedDescription)")
             }
         } */
    }
}

/* extension LaunchesQuery.Data.LaunchesPast: Identifiable {
     var id: String { mission_name }

     var asLaunch: Launch {
         Launch(
             missionName: mission_name ?? "Unknown",
             launchDateUTC: launch_date_utc ?? "Unknown",
             rocketName: rocket?.rocket_name ?? "Unknown"
         )
     }
 } */

internal struct Launch: Identifiable {
    var id: String { missionName }
    let missionName: String
    let launchDateUTC: String
    let rocketName: String
}
