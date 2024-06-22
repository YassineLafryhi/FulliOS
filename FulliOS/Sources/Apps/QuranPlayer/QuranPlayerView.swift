//
//  QuranPlayerView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 6/6/2024.
//

import SwiftUI

internal struct QuranPlayerView: View {
    @State private var selectedReciter = Constants.QuranPlayerApp.tvQuranReciters[0]
    @State private var selectedChapter = "001"
    private let reciters = Constants.QuranPlayerApp.tvQuranReciters
    private let chapters = (1 ... 114).map { String(format: "%03d", $0) }

    var body: some View {
        VStack {
            Picker("Select Reciter", selection: $selectedReciter) {
                ForEach(reciters, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.palette)

            Picker("Select Chapter", selection: $selectedChapter) {
                ForEach(chapters, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.wheel)

            VStack {
                FButton("تشغيل", type: .success, direction: .RTL) {
                    playAudio()
                }
                FButton("إيقاف التشغيل", type: .danger, direction: .RTL) {
                    MP3Streamer.shared.stop()
                }
                FButton("إعادة التشغيل", type: .primary, direction: .RTL) {
                    MP3Streamer.shared.restart()
                }
                FButton("استئناف التشغيل", type: .info, direction: .RTL) {
                    MP3Streamer.shared.release()
                }
            }
        }
    }

    private func playAudio() {
        let url = "\(Constants.QuranPlayerApp.tvQuranApi)\(selectedReciter)/\(selectedChapter).mp3"
        Logger.shared.log(url)
        MP3Streamer.shared.initialize(with: url)
        MP3Streamer.shared.play()
    }
}
