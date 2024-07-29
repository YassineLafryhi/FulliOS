//
//  DevQuizView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 23/7/2024.
//

import SwiftUI

internal struct DevQuizView: View {
    @State private var selectedLevel = 0
    let levels = ["Beginner", "Intermediate", "Advanced"]

    var body: some View {
        NavigationView {
            VStack {
                Text("iOS Development Quiz")
                    .font(.largeTitle)
                    .padding()

                Picker("Select Level", selection: $selectedLevel) {
                    ForEach(0 ..< levels.count) { index in
                        Text(levels[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                NavigationLink(destination: QuizView(level: levels[selectedLevel])) {
                    Text("Start Quiz")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
