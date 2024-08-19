//
//  AudioVideoEditorView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 26/7/2024.
//

import AVFoundation
import AVKit
// import FFmpegKit
import Photos
import SwiftUI

internal struct AudioVideoEditorView: View {
    @State private var selectedURL: URL?
    @State private var trimStart: Double = 0
    @State private var trimEnd: Double = 0
    @State private var fileName = ""
    @State private var savedFiles: [URL] = []

    var body: some View {
        VStack {
            Button("Select Video") {}

            if let url = selectedURL {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 200)

                HStack {
                    Slider(value: $trimStart, in: 0 ... trimEnd)
                    Slider(value: $trimEnd, in: trimStart ... getDuration(url: url))
                }

                TextField("File Name", text: $fileName)

                Button("Trim and Export") {
                    trimAndExport()
                }
            }

            List(savedFiles, id: \.self) { file in
                HStack {
                    Text(file.lastPathComponent)
                    Spacer()
                    Button("Play") {}
                }
            }
        }
        .onAppear {
            loadSavedFiles()
        }
    }

    func getDuration(url: URL) -> Double {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        return CMTimeGetSeconds(duration)
    }

    func trimAndExport() {
        guard let url = selectedURL else { return }

        let asset = AVAsset(url: url)
        let composition = AVMutableComposition()

        guard
            let videoTrack = asset.tracks(withMediaType: .video).first,
            let audioTrack = asset.tracks(withMediaType: .audio).first else {
            return
        }

        let videoCompositionTrack = composition.addMutableTrack(
            withMediaType: .video,
            preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioCompositionTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: kCMPersistentTrackID_Invalid)

        let startTime = CMTime(seconds: trimStart, preferredTimescale: 600)
        let endTime = CMTime(seconds: trimEnd, preferredTimescale: 600)
        let timeRange = CMTimeRange(start: startTime, end: endTime)

        do {
            try videoCompositionTrack?.insertTimeRange(timeRange, of: videoTrack, at: .zero)
            try audioCompositionTrack?.insertTimeRange(timeRange, of: audioTrack, at: .zero)
        } catch {
            print("Error creating composition: \(error)")
            return
        }

        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            return
        }

        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("\(fileName).mp4")

        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4

        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("Export completed")
                DispatchQueue.main.async {
                    savedFiles.append(outputURL)
                }
            case .failed:
                print("Export failed: \(String(describing: exportSession.error))")
            default:
                break
            }
        }
    }

    /* func trimAndExport() {
         guard let url = selectedURL else { return }

         let startTime = String(format: "%.2f", trimStart)
         let duration = String(format: "%.2f", trimEnd - trimStart)

         let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(fileName).mp4")

         let command = "-ss \(startTime) -i '\(url.path)' -t \(duration) -c copy '\(outputURL.path)'"

         FFmpegKit.execute(command) { session in
             guard let session = session else { return }

             let returnCode = session.getReturnCode()

             DispatchQueue.main.async {
                 if ReturnCode.isSuccess(returnCode) {
                     print("Export completed")
                     self.savedFiles.append(outputURL)
                 } else {
                     print("Export failed with state \(session.getState()) and rc \(returnCode?.description ?? "")")
                 }
             }
         }
     } */

    func loadSavedFiles() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            savedFiles = fileURLs.filter { $0.pathExtension == "mp4" }
        } catch {
            print("Error loading saved files: \(error)")
        }
    }
}
