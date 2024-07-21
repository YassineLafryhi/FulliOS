//
//  SoundAnalysisView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 21/7/2024.
//

import SwiftUI

struct SoundAnalysisView: View {
    @StateObject private var audioAnalyzer = AudioAnalyzer()

    var body: some View {
        VStack {
            Text(audioAnalyzer.identifiedSounds)
                .padding()
            Spacer()
        }
        .onAppear {}
    }
}
