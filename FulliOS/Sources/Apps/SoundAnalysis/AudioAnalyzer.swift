//
//  AudioAnalyzer.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 21/7/2024.
//

import AVFoundation
import Foundation
import SoundAnalysis

internal class AudioAnalyzer: NSObject, ObservableObject, AVAudioRecorderDelegate {
    private var audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    private var audioSession = AVAudioSession.sharedInstance()
    private var soundClassifier: SNAudioStreamAnalyzer?
    private var request: SNClassifySoundRequest?
    private let analysisQueue = DispatchQueue(label: "AudioAnalysis")

    @Published var identifiedSounds = "Listening..."

    override init() {
        super.init()
        prepareAudioSession()
        startAudioEngine()
        setupSoundAnalysis()
    }

    private func prepareAudioSession() {
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    private func startAudioEngine() {
        inputNode = audioEngine.inputNode
        let recordingFormat = inputNode!.outputFormat(forBus: 0)
        inputNode!.installTap(onBus: 0, bufferSize: 1_024, format: recordingFormat) { [weak self] buffer, when in
            self?.analysisQueue.async {
                self?.soundClassifier!.analyze(buffer, atAudioFramePosition: when.sampleTime)
            }
        }

        do {
            try audioEngine.start()
        } catch {
            print("Could not start audio engine: \(error)")
        }
    }

    private func setupSoundAnalysis() {
        soundClassifier = SNAudioStreamAnalyzer(format: inputNode!.outputFormat(forBus: 0))
        do {
            request = try SNClassifySoundRequest(classifierIdentifier: SNClassifierIdentifier.version1)
            try soundClassifier!.add(request!, withObserver: self)
        } catch {
            print("Unable to prepare request: \(error)")
        }
    }
}

extension AudioAnalyzer: SNResultsObserving {
    func request(_: SNRequest, didProduce result: SNResult) {
        guard
            let result = result as? SNClassificationResult,
            let classification = result.classifications.first else { return }

        DispatchQueue.main.async {
            self.identifiedSounds = "Detected: \(classification.identifier) Confidence: \(classification.confidence)"
        }
    }

    func request(_: SNRequest, didFailWithError error: Error) {
        print("The analysis failed: \(error)")
    }

    func requestDidComplete(_: SNRequest) {
        print("The request completed successfully!")
    }
}
