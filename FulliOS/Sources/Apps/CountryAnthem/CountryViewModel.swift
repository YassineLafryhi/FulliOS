//
//  CountryAnthemViewModel.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 30/8/2024.
//

import AudioKit
import AVFoundation

internal class CountryAnthemViewModel: ObservableObject {
    @Published var countries: [Country]
    @Published var isPlaying: [UUID: Bool] = [:]

    private var audioPlayer: AudioPlayer?
    private var audioEngine = AudioEngine()
    private var mixer = Mixer()

    init() {
        countries = [
            Country(name: "Morocco", flag: "🇲🇦", anthemFileName: "Morocco.mp3"),
            Country(name: "Kuwait", flag: "🇰🇼", anthemFileName: "Kuwait.mp3"),
            Country(name: "Lithuania", flag: "🇱🇹", anthemFileName: "Lithuania.mp3"),
            Country(name: "Poland", flag: "🇵🇱", anthemFileName: "Poland.mp3"),
            Country(name: "Tunisia", flag: "🇹🇳", anthemFileName: "Tunisia.mp3"),
            Country(name: "Greece", flag: "🇬🇷", anthemFileName: "Greece.mp3"),
            Country(name: "Italy", flag: "🇮🇹", anthemFileName: "Italy.mp3"),
            Country(name: "Libya", flag: "🇱🇾", anthemFileName: "Libya.mp3"),
            Country(name: "Algeria", flag: "🇩🇿", anthemFileName: "Algeria.mp3"),
            Country(name: "Oman", flag: "🇴🇲", anthemFileName: "Oman.mp3"),
            Country(name: "Syria", flag: "🇸🇾", anthemFileName: "Syria.mp3"),
            Country(name: "Finland", flag: "🇫🇮", anthemFileName: "Finland.mp3"),
            Country(name: "Turkey", flag: "🇹🇷", anthemFileName: "Turkey.mp3"),
            Country(name: "Iraq", flag: "🇮🇶", anthemFileName: "Iraq.mp3"),
            Country(name: "Lebanon", flag: "🇱🇧", anthemFileName: "Lebanon.mp3"),
            Country(name: "Slovenia", flag: "🇸🇮", anthemFileName: "Slovenia.mp3"),
            Country(name: "Latvia", flag: "🇱🇻", anthemFileName: "Latvia.mp3"),
            Country(name: "Montenegro", flag: "🇲🇪", anthemFileName: "Montenegro.mp3"),
            Country(name: "Romania", flag: "🇷🇴", anthemFileName: "Romania.mp3")
        ]

        Settings.bufferLength = .medium
        audioEngine.output = mixer

        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine did not start: \(error.localizedDescription)")
        }
    }

    func playAnthem(for country: Country) {
        guard let fileURL = Bundle.main.url(forResource: country.anthemFileName, withExtension: nil) else {
            print("Anthem file not found: \(country.anthemFileName)")
            return
        }

        do {
            let audioFile = try AVAudioFile(forReading: fileURL)
            let newPlayer = AudioPlayer(file: audioFile)
            audioEngine.output = newPlayer
            if let newPlayer = newPlayer {
                mixer.addInput(newPlayer)
                audioPlayer = newPlayer

                do {
                    try audioEngine.start()
                } catch {
                    print("AudioEngine failed to start: \(error.localizedDescription)")
                    return
                }

                audioPlayer?.completionHandler = { [weak self] in
                    DispatchQueue.main.async {
                        self?.isPlaying[country.id] = false
                        self?.mixer.removeInput(newPlayer)
                    }
                }

                audioPlayer?.play()
                isPlaying[country.id] = true
            }
        } catch {
            print("Failed to play anthem: \(error.localizedDescription)")
        }
    }

    func stopAnthem(for country: Country) {
        audioPlayer?.stop()
        isPlaying[country.id] = false
        if let player = audioPlayer {
            mixer.removeInput(player)
        }
    }
}
