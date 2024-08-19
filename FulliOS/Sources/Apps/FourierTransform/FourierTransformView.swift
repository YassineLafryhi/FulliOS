//
//  FourierView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 1/8/2024.
//

import SwiftUI

internal struct FourierTransformView: View {
    @State private var signal: [Float] = Array(repeating: 0.0, count: 256)
    @State private var real: [Float] = Array(repeating: 0.0, count: 256)
    @State private var imag: [Float] = Array(repeating: 0.0, count: 256)
    @State private var amplitude: [Float] = Array(repeating: 0.0, count: 256)

    var body: some View {
        VStack {
            SignalPlot(signal: signal)
                .frame(height: 200)
            FourierPlot(amplitude: amplitude)
                .frame(height: 200)
        }
        .onAppear {
            generateSignal()
            fourierTransform(signal: &signal, real: &real, imag: &imag)
            calculateAmplitude(real: real, imag: imag, amplitude: &amplitude)
        }
    }

    func generateSignal() {
        for i in 0 ..< 256 {
            signal[i] = sin(2 * Float.pi * 10 * Float(i) / 256) + 0.5 * sin(2 * Float.pi * 20 * Float(i) / 256)
        }
    }

    func fourierTransform(signal: inout [Float], real: inout [Float], imag: inout [Float]) {
        fourier_transform(&signal, 256, &real, &imag)
    }

    func calculateAmplitude(real: [Float], imag: [Float], amplitude: inout [Float]) {
        for i in 0 ..< 256 {
            amplitude[i] = sqrt(real[i] * real[i] + imag[i] * imag[i])
        }
    }
}

internal struct SignalPlot: View {
    let signal: [Float]

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for i in 0 ..< signal.count {
                    let x = CGFloat(i) / CGFloat(signal.count - 1) * geometry.size.width
                    let y = geometry.size.height / 2 - CGFloat(signal[i]) * geometry.size.height / 2
                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}

internal struct FourierPlot: View {
    let amplitude: [Float]

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for i in 0 ..< amplitude.count {
                    let x = CGFloat(i) / CGFloat(amplitude.count - 1) * geometry.size.width
                    let y = geometry.size.height / 2 - CGFloat(amplitude[i]) * geometry.size.height / 2
                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.red, lineWidth: 2)
        }
    }
}
