//
//  QuoteWidget.swift
//  QuoteWidget
//
//  Created by Yassine Lafryhi on 23/7/2024.
//

import SwiftUI
import WidgetKit

struct Quote: Identifiable {
    let id = UUID()
    let text: String
    let author: String
}

struct Provider: TimelineProvider {
    let quotes = [
        Quote(text: "Be the change you wish to see in the world.", author: "Mahatma Gandhi"),
        Quote(text: "Stay hungry, stay foolish.", author: "Steve Jobs"),
        Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
        Quote(text: "In the middle of difficulty lies opportunity.", author: "Albert Einstein"),
        Quote(text: "Imagination is more important than knowledge.", author: "Albert Einstein")
    ]

    func placeholder(in _: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quote: quotes[0])
    }

    func getSnapshot(in _: Context, completion: @escaping (QuoteEntry) -> ()) {
        let entry = QuoteEntry(date: Date(), quote: quotes.randomElement()!)
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [QuoteEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = QuoteEntry(date: entryDate, quote: quotes.randomElement()!)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: Quote
}

struct QuoteWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.quote.text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(4)

            Spacer()

            Text("- \(entry.quote.author)")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
        }
        .padding()
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

@main
struct QuoteWidget: Widget {
    let kind = "QuoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QuoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quote of the Day")
        .description("This widget displays an inspiring quote.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}
