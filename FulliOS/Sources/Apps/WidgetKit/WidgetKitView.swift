//
//  WidgetKitView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 23/7/2024.
//

import SwiftUI
import WidgetKit

struct WidgetKitView: View {
    var body: some View {
        VStack {
            Text("Quote of the Day Widget")
                .font(.title)
                .padding()

            FButton("Add Widget") {
                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
    }
}
