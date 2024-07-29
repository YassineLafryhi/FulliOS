//
//  AccelerateShowcaseView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import Accelerate
import SwiftUI

internal struct AccelerateShowcaseView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ImageProcessingView()) {
                    Text("Image Processing")
                }
                NavigationLink(destination: MatrixOperationsView()) {
                    Text("Matrix Operations")
                }
                NavigationLink(destination: SignalProcessingView()) {
                    Text("Signal Processing")
                }
            }
            .navigationTitle("Accelerate Framework Showcase")
        }
    }
}

internal struct ImageProcessingView: View {
    @State private var inputImage: UIImage
    @State private var outputImage = UIImage()

    init() {
        _inputImage = State(initialValue: UIImage(resource: R.image.face)!)
    }

    var body: some View {
        VStack {
            Image(uiImage: inputImage)
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            Button("Apply Grayscale Filter") {
                outputImage = applyGrayscaleFilter(to: inputImage)
            }

            Image(uiImage: outputImage)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
        }
        .navigationTitle("Image Processing")
        .padding()
    }

    func applyGrayscaleFilter(to image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }

        let width = cgImage.width
        let height = cgImage.height

        let colorSpace = CGColorSpaceCreateDeviceGray()
        var pixels = [UInt8](repeating: 0, count: width * height)

        let context = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.none.rawValue)

        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        if let outputCGImage = context?.makeImage() {
            return UIImage(cgImage: outputCGImage)
        }
        return image
    }
}

internal struct MatrixOperationsView: View {
    @State private var matrixA = [[Double]]([[1, 2], [3, 4]])
    @State private var matrixB = [[Double]]([[5, 6], [7, 8]])
    @State private var resultMatrix = [[Double]]()

    var body: some View {
        VStack {
            Text("Matrix A:")
            ForEach(matrixA, id: \.self) { row in
                Text(row.map { String($0) }.joined(separator: " "))
            }

            Text("Matrix B:")
            ForEach(matrixB, id: \.self) { row in
                Text(row.map { String($0) }.joined(separator: " "))
            }

            Button("Multiply Matrices") {
                resultMatrix = multiplyMatrices(matrixA, matrixB)
            }

            Text("Result Matrix:")
            ForEach(resultMatrix, id: \.self) { row in
                Text(row.map { String($0) }.joined(separator: " "))
            }
        }
        .navigationTitle("Matrix Operations")
        .padding()
    }

    func multiplyMatrices(_ a: [[Double]], _ b: [[Double]]) -> [[Double]] {
        let rowsA = a.count
        let colsA = a[0].count
        let colsB = b[0].count

        var result = [[Double]](repeating: [Double](repeating: 0.0, count: colsB), count: rowsA)

        let flatA = a.flatMap { $0 }
        let flatB = b.flatMap { $0 }

        var flatResult = [Double](repeating: 0.0, count: rowsA * colsB)

        flatA.withUnsafeBufferPointer { ptrA in
            flatB.withUnsafeBufferPointer { ptrB in
                flatResult.withUnsafeMutableBufferPointer { ptrResult in
                    vDSP_mmulD(
                        ptrA.baseAddress!,
                        1,
                        ptrB.baseAddress!,
                        1,
                        ptrResult.baseAddress!,
                        1,
                        vDSP_Length(rowsA),
                        vDSP_Length(colsB),
                        vDSP_Length(colsA))
                }
            }
        }

        for i in 0 ..< rowsA {
            result[i] = Array(flatResult[i * colsB ..< (i + 1) * colsB])
        }

        return result
    }
}

internal struct SignalProcessingView: View {
    @State private var inputSignal = [Float](repeating: 0.0, count: 512)
    @State private var outputSignal = [Float](repeating: 0.0, count: 512)

    var body: some View {
        VStack {
            Button("Generate Sine Wave") {
                inputSignal = generateSineWave(frequency: 5.0, sampleCount: 512)
            }

            Button("Apply FFT") {
                outputSignal = applyFFT(to: inputSignal)
            }

            Text("Input Signal")
            ScrollView {
                Text(inputSignal.map { String($0) }.joined(separator: ", "))
            }
            .frame(height: 100)

            Text("Output Signal (FFT)")
            ScrollView {
                Text(outputSignal.map { String($0) }.joined(separator: ", "))
            }
            .frame(height: 100)
        }
        .navigationTitle("Signal Processing")
        .padding()
    }

    func generateSineWave(frequency: Float, sampleCount: Int) -> [Float] {
        let phaseIncrement = 2 * .pi * frequency / Float(sampleCount)
        return (0 ..< sampleCount).map { i in
            sin(phaseIncrement * Float(i))
        }
    }

    func applyFFT(to signal: [Float]) -> [Float] {
        var real = signal
        var imaginary = [Float](repeating: 0.0, count: signal.count)

        var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)

        let length = vDSP_Length(floor(log2(Float(signal.count))))
        let fftSetup = vDSP_create_fftsetup(length, FFTRadix(FFT_RADIX2))!

        vDSP_fft_zip(fftSetup, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))

        vDSP_destroy_fftsetup(fftSetup)

        return real
    }
}
