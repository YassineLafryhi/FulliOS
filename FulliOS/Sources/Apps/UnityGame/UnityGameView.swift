//
//  UnityGameView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 22/7/2024.
//

import SwiftUI

struct UnityGameView: View {
    var body: some View {
        VStack {
            FButton("Open Unity Game") {
                UnityBridge.shared.showUnity()
            }
        }
    }
}
