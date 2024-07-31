//
//  FText.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/7/2024.
//

import SwiftUI

internal enum FTextType {
    case primary, secondary, success, danger, info, warning
}

internal enum FTextStyle {
    case title, subtitle, body, caption
}

internal struct FText: View {
    var text: String
    var type: FTextType
    var style: FTextStyle
    var alignment: TextAlignment
    var direction: FButtonDirection

    init(
        _ text: String,
        type: FTextType = .primary,
        style: FTextStyle = .body,
        alignment: TextAlignment = .leading,
        direction: FButtonDirection = .LTR) {
        self.text = text
        self.type = type
        self.style = style
        self.alignment = alignment
        self.direction = direction
    }

    var textColor: Color {
        switch type {
        case .primary:
            Constants.AppColors.darkPrimaryColor
        case .secondary:
            Constants.AppColors.darkSecondaryColor
        case .success:
            Constants.AppColors.darkSuccessColor
        case .danger:
            Constants.AppColors.darkDangerColor
        case .info:
            Constants.AppColors.darkInfoColor
        case .warning:
            Constants.AppColors.darkWarningColor
        }
    }

    var body: some View {
        Text(text)
            .font(
                direction == .RTL
                    ? .custom(R.font.dinNextLTW23Medium.name, size: 24)
                    : .custom(
                        R.font.balsamiqSansRegular.name,
                        size: 24))
            .foregroundColor(textColor)
            .multilineTextAlignment(alignment)
            .frame(maxWidth: .infinity, alignment: frameAlignment)
            .padding()
    }

    private var frameAlignment: Alignment {
        switch alignment {
        case .center:
            .center
        case .leading:
            direction == .RTL ? .trailing : .leading
        case .trailing:
            direction == .RTL ? .leading : .trailing
        }
    }
}
