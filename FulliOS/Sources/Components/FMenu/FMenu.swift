//
//  FMenu.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import SwiftUI

internal struct FMenu: View {
    var menuItem: DashboardMenuItem

    var body: some View {
        NavigationLink(destination: menuItem.destinationView) {
            VStack {
                Image(menuItem.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                Text(menuItem.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .padding(.top, 6)
                    .font(.custom(R.font.charlatanDEMO.name, size: 20))
            }
            .frame(width: 160)
            .padding(8)
            .background(Color.white)
            .cornerRadius(28)
            .shadow(radius: 4)
            .accessibilityLabel(menuItem.testTag)
        }
    }
}
