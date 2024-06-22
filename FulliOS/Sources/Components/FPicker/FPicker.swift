//
//  FPicker.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 7/6/2024.
//

import SwiftUI

internal enum FPickerType {
    case primary, secondary, success, danger, info, warning
}

internal struct FPicker<T: Hashable>: View {
    var title: String
    var items: [T]
    @Binding var selectedItem: T
    var type: FPickerType
    var textAlignment: TextAlignment

    var gradientColors: [Color] {
        switch type {
        case .primary:
            [Constants.AppColors.lightPrimaryColor, Constants.AppColors.darkPrimaryColor]
        case .secondary:
            [Constants.AppColors.lightSecondaryColor, Constants.AppColors.darkSecondaryColor]
        case .success:
            [Constants.AppColors.lightSuccessColor, Constants.AppColors.darkSuccessColor]
        case .danger:
            [Constants.AppColors.lightDangerColor, Constants.AppColors.darkDangerColor]
        case .info:
            [Constants.AppColors.lightInfoColor, Constants.AppColors.darkInfoColor]
        case .warning:
            [Constants.AppColors.lightWarningColor, Constants.AppColors.darkWarningColor]
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .center)
            Picker(selection: $selectedItem, label: Text("")) {
                ForEach(items, id: \.self) { item in
                    Text("\(item)").tag(item)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .cornerRadius(12))
        }
        .padding(.horizontal)
    }
}
