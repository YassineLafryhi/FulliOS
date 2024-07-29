//
//  HandwritingRecognitionView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/7/2024.
//

import PencilKit
import SwiftUI
import Vision

internal struct HandwritingRecognitionView: View {
    @State private var canvasView = PKCanvasView()
    @State private var recognizedText = "Write something using Apple Pencil or your finger, then tap 'Recognize Text'."

    var body: some View {
        NavigationView {
            VStack {
                Text(recognizedText)
                    .padding()

                CanvasView(canvasView: $canvasView)
                    .frame(height: 300)
                    .border(Color.gray, width: 1)

                Button("Recognize Text") {
                    recognizeText(from: canvasView.drawing)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .navigationTitle("Handwriting Recognition")
            .padding()
        }
    }

    func recognizeText(from drawing: PKDrawing) {
        let image = drawing.image(from: canvasView.bounds, scale: 1.0)
        guard let cgImage = image.cgImage else {
            recognizedText = "Unable to convert drawing to CGImage."
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                recognizedText = "Error: \(error.localizedDescription)"
                return
            }
            recognizedText = ""
            for observation in request.results as? [VNRecognizedTextObservation] ?? [] {
                guard let candidate = observation.topCandidates(1).first else { continue }
                recognizedText += candidate.string + "\n"
            }
        }

        request.recognitionLevel = .accurate

        let requests = [request]
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform(requests)
            } catch {
                DispatchQueue.main.async {
                    recognizedText = "Failed to perform request: \(error.localizedDescription)"
                }
            }
        }
    }
}

internal struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeUIView(context _: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        return canvasView
    }

    func updateUIView(_: PKCanvasView, context _: Context) {}
}
