//
//  ImageClassificationView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 26/7/2024.
//

import SwiftUI
import TensorFlowLite
import UIKit

struct ImageClassificationView: View {
    @State private var selectedImage: UIImage?
    @State private var classificationResult = ""
    @State private var isShowingImagePicker = false

    private let imageClassifier = ImageClassifier()

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("No image selected")
                    .frame(height: 300)
            }

            Button("Select Image") {
                isShowingImagePicker = true
            }
            .padding()

            Text("Classification Result:")
                .font(.headline)
            Text(classificationResult)
                .padding()
        }
        .sheet(isPresented: $isShowingImagePicker, onDismiss: classifyImage) {
            PhotoPicker(image: $selectedImage)
        }
    }

    private func classifyImage() {
        guard let image = selectedImage else { return }

        if let result = imageClassifier.classify(image: image) {
            classificationResult = "Class: \(result.label), Confidence: \(String(format: "%.2f", result.confidence))"
        } else {
            classificationResult = "Classification failed"
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: UIImagePickerController, context _: UIViewControllerRepresentableContext<PhotoPicker>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func imagePickerController(
            _: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

class ImageClassifier {
    private var interpreter: Interpreter?
    private let modelPath = Bundle.main.path(forResource: "mobilenet_v1_1.0_224", ofType: "tflite")
    private let labelPath = Bundle.main.path(forResource: "labels", ofType: "txt")
    private var labels: [String] = []

    init() {
        setupInterpreter()
        loadLabels()
    }

    private func setupInterpreter() {
        guard let modelPath = modelPath else {
            print("Failed to load the model file")
            return
        }

        do {
            interpreter = try Interpreter(modelPath: modelPath)
            try interpreter?.allocateTensors()
        } catch {
            print("Failed to create the interpreter: \(error.localizedDescription)")
        }
    }

    private func loadLabels() {
        guard
            let labelPath = labelPath,
            let contents = try? String(contentsOfFile: labelPath) else {
            print("Failed to load the label file")
            return
        }

        labels = contents.components(separatedBy: .newlines)
    }

    func classify(image: UIImage) -> (label: String, confidence: Float)? {
        guard
            let interpreter = interpreter,
            let resizedImage = image.resize(to: CGSize(width: 224, height: 224)),
            let rgbData = resizedImage.rgbData else {
            return nil
        }

        do {
            try interpreter.copy(rgbData, toInputAt: 0)
            try interpreter.invoke()

            let outputTensor = try interpreter.output(at: 0)

            let results = outputTensor.data.withUnsafeBytes { pointer in
                Array(UnsafeBufferPointer<Float32>(
                    start: pointer.baseAddress?.assumingMemoryBound(to: Float32.self),
                    count: pointer.count / MemoryLayout<Float32>.stride))
            }

            if let (index, confidence) = results.enumerated().max(by: { $0.1 < $1.1 }) {
                return (label: labels[index], confidence: confidence)
            }
        } catch {
            print("Failed to invoke the interpreter: \(error.localizedDescription)")
        }

        return nil
    }
}

extension UIImage {
    func resize(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    var rgbData: Data? {
        guard let cgImage = cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let byteCount = bytesPerRow * height

        var rawBytes = [UInt8](repeating: 0, count: byteCount)
        guard
            let context = CGContext(
                data: &rawBytes,
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        return Data(bytes: rawBytes, count: byteCount)
    }
}
