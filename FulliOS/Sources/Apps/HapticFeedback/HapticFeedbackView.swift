//
//  HapticFeedbackView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 23/7/2024.
//

import CoreHaptics
import SwiftUI

struct HapticFeedbackView: View {
    @State private var engine: CHHapticEngine?

    var body: some View {
        VStack(spacing: 20) {
            FButton("Simple Tap") { simpleHaptic() }
            FButton("Complex Success") { complexSuccess() }
            FButton("Heartbeat") { heartbeat() }
            FButton("Crescendo") { crescendo() }
            FButton("Drum Roll") { drumRoll() }
            FButton("Morse Code SOS") { morseCodeSOS() }
            FButton("Gentle Waves") { gentleWaves() }
            FButton("Fireworks") { fireworks() }
            FButton("Alarm Clock") { alarmClock() }
            FButton("Typewriter") { typewriter() }
        }
        .onAppear(perform: prepareHaptics)
    }

    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error creating the engine: \(error.localizedDescription)")
        }
    }

    func simpleHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }

    func complexSuccess() {
        createAndPlayHapticPattern([
            (1.0, 1.0, 0),
            (0.8, 0.4, 0.1),
            (0.6, 0.6, 0.2)
        ])
    }

    func heartbeat() {
        createAndPlayHapticPattern([
            (1.0, 0.5, 0),
            (0.5, 0.2, 0.1),
            (1.0, 0.5, 0.4),
            (0.5, 0.2, 0.5)
        ])
    }

    func crescendo() {
        createAndPlayHapticPattern([
            (0.2, 0.2, 0),
            (0.4, 0.4, 0.2),
            (0.6, 0.6, 0.4),
            (0.8, 0.8, 0.6),
            (1.0, 1.0, 0.8)
        ])
    }

    func drumRoll() {
        var events: [(Double, Double, TimeInterval)] = []
        for i in 0 ..< 20 {
            events.append((0.5, 0.8, TimeInterval(i) * 0.05))
        }
        createAndPlayHapticPattern(events)
    }

    func morseCodeSOS() {
        let dot = (1.0, 0.5, 0.1)
        let dash = (1.0, 0.5, 0.3)
        let pause = (0.0, 0.0, 0.1)
        let letterPause = (0.0, 0.0, 0.3)

        createAndPlayHapticPattern([
            dot, pause, dot, pause, dot,
            letterPause,
            dash, pause, dash, pause, dash,
            letterPause,
            dot, pause, dot, pause, dot
        ])
    }

    func gentleWaves() {
        var events: [(Double, Double, TimeInterval)] = []
        for i in 0 ..< 10 {
            let intensity = Double(i % 5 + 1) / 5.0
            events.append((intensity, 0.5, TimeInterval(i) * 0.2))
        }
        createAndPlayHapticPattern(events)
    }

    func fireworks() {
        createAndPlayHapticPattern([
            (1.0, 1.0, 0),
            (0.8, 0.8, 0.1),
            (0.6, 0.6, 0.2),
            (0.4, 0.4, 0.3),
            (0.2, 0.2, 0.4),
            (1.0, 1.0, 0.5),
            (0.7, 0.7, 0.6),
            (0.5, 0.5, 0.7)
        ])
    }

    func alarmClock() {
        var events: [(Double, Double, TimeInterval)] = []
        for i in 0 ..< 6 {
            events.append((1.0, 1.0, TimeInterval(i) * 0.5))
            events.append((0.5, 0.5, TimeInterval(i) * 0.5 + 0.25))
        }
        createAndPlayHapticPattern(events)
    }

    func typewriter() {
        var events: [(Double, Double, TimeInterval)] = []
        for i in 0 ..< 10 {
            events.append((0.6, 1.0, TimeInterval(i) * 0.1))
        }
        events.append((1.0, 0.8, 1.0)) // Carriage return
        createAndPlayHapticPattern(events)
    }

    func createAndPlayHapticPattern(_ events: [(Double, Double, TimeInterval)]) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            let pattern = try CHHapticPattern(events: events.map {
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: Float($0.0)),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: Float($0.1))
                    ],
                    relativeTime: $0.2)
            }, parameters: [])

            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
}
