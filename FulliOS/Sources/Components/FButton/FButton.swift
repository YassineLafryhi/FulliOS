//
//  FButton.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 7/6/2024.
//

import SwiftUI

internal enum FButtonType {
    case primary, secondary, success, danger, info, warning
}

internal enum FButtonDirection {
    case RTL, LTR
}

internal struct FButton: View {
    var title: String
    var type: FButtonType
    var direction: FButtonDirection
    var textAlignment: TextAlignment
    var action: () -> Void

    @State private var isPressed = false

    init(
        _ title: String,
        type: FButtonType = .primary,
        direction: FButtonDirection = .LTR,
        textAlignment: TextAlignment = .center,
        action: @escaping () -> Void,
        isPressed: Bool = false)
    {
        self.title = title
        self.type = type
        self.direction = direction
        self.textAlignment = textAlignment
        self.action = action
        self.isPressed = isPressed
    }

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
        Button(action: {
            withAnimation(Animation.easeIn(duration: 0.2)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(Animation.easeOut(duration: 0.2)) {
                    isPressed = false
                }
                action()
            }
        }) {
            Text(title)
                .font(
                    direction == .RTL
                        ? .custom(R.font.dinNextLTW23Medium.name, size: 24)
                        : .custom(
                            R.font.balsamiqSansRegular.name,
                            size: 24))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: alignment)
                .background(
                    LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .cornerRadius(18)
                        .scaleEffect(isPressed ? 0.95 : 1.0))
        }
        .padding(.horizontal)
    }

    private var alignment: Alignment {
        switch textAlignment {
        case .center:
            .center
        case .leading:
            .leading
        case .trailing:
            .trailing
        }
    }
}
