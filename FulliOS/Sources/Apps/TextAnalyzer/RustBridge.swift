//
//  RustBridge.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/7/2024.
//

import Foundation

internal class RustBridge {
    static func countWords(_ text: String) -> Int {
        text.withCString { cString in
            Int(count_words(cString))
        }
    }

    static func countCharacters(_ text: String) -> Int {
        text.withCString { cString in
            Int(count_characters(cString))
        }
    }

    static func simpleSentimentAnalysis(_ text: String) -> Double {
        text.withCString { cString in
            Double(simple_sentiment_analysis(cString))
        }
    }
}
