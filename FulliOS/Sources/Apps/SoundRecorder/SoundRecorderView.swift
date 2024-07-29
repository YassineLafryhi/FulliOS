//
//  SoundRecorderView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 19/7/2024.
//

import AVFoundation
import SwiftUI

internal struct SoundRecorderView: View {
    @StateObject private var audioRecorder = AudioRecorder()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                        HStack {
                            Text(recording.fileURL.lastPathComponent)
                            Spacer()
                            Button(action: {
                                audioRecorder.playRecording(recording: recording)
                            }) {
                                Image(systemName: "play.circle")
                            }
                            .padding(.trailing, 10)
                            Button(action: {
                                audioRecorder.deleteRecording(recording: recording)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                HStack {
                    if audioRecorder.isRecording {
                        Button(action: {
                            audioRecorder.stopRecording()
                        }) {
                            Text("Stop Recording")
                                .foregroundColor(.red)
                        }
                    } else {
                        Button(action: {
                            audioRecorder.startRecording()
                        }) {
                            Text("Start Recording")
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Sound Recorder")
        }
    }
}

internal class AudioRecorder: NSObject, ObservableObject {
    @Published var recordings: [Recording] = []
    @Published var isRecording = false

    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?

    override init() {
        super.init()
        fetchRecordings()
    }

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12_000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            let fileURL = getDocumentsDirectory().appendingPathComponent(UUID().uuidString + ".m4a")
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()

            isRecording = true
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        fetchRecordings()
    }

    func playRecording(recording: Recording) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recording.fileURL)
            audioPlayer?.play()
        } catch {
            print("Failed to play recording: \(error.localizedDescription)")
        }
    }

    func deleteRecording(recording: Recording) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: recording.fileURL)
            fetchRecordings()
        } catch {
            print("Failed to delete recording: \(error.localizedDescription)")
        }
    }

    private func fetchRecordings() {
        let fileManager = FileManager.default
        let documentsDirectory = getDocumentsDirectory()
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            recordings = files.map { Recording(fileURL: $0) }.sorted { $0.createdAt > $1.createdAt }
        } catch {
            print("Failed to fetch recordings: \(error.localizedDescription)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            fetchRecordings()
        }
    }
}

internal struct Recording {
    let fileURL: URL
    var createdAt: Date {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            return attributes[FileAttributeKey.creationDate] as? Date ?? Date()
        } catch {
            return Date()
        }
    }
}
