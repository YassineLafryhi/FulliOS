//
//  Constants.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import Foundation
import SwiftUI

internal enum Constants {
    enum Shared {
        static let defaultDateAndTimeFormat = "dd-MM-yyyy HH:mm:ss"
        static let defaultDateAndTimeFormatForNames = "ddMMyyyyHHmmss"
        static let defaultDateFormat = "dd-MM-yyyy"
    }

    enum AppColors {
        static var lightPrimaryColor = Color(hex: "#9b59b6")
        static var darkPrimaryColor = Color(hex: "#8e44ad")

        static var lightSecondaryColor = Color(hex: "#34495e")
        static var darkSecondaryColor = Color(hex: "#2c3e50")

        static var lightSuccessColor = Color(hex: "#2ecc71")
        static var darkSuccessColor = Color(hex: "#27ae60")

        static var lightInfoColor = Color(hex: "#3498db")
        static var darkInfoColor = Color(hex: "#2980b9")

        static var lightWarningColor = Color(hex: "#f1c40f")
        static var darkWarningColor = Color(hex: "#f1c40f")

        static var lightDangerColor = Color(hex: "#e74c3c")
        static var darkDangerColor = Color(hex: "#c0392b")
    }

    enum QuranPlayerApp {
        static let tvQuranApi = "https://download.tvquran.com/download/TvQuran.com__"
        static let tvQuranReciters = ["Al-Ghamdi", "Fares.Abbad", "Al-Ajmy"]
    }

    enum TemperatureChartApp {
        // TODO: Update this after launching Vapor Server
        static let wsUrl = "ws://192.168.1.239:8080/temperature"
    }

    enum NewsApp {
        static let newsApi = "https://newsapi.org/v2/everything"
        static let reversedDateFormat = "yyyy-MM-dd"
    }
}
