/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 Contains the object recognition view controller for the Breakfast Finder.

 The object detector model, located at BreakfastFinder/ObjectDetector.mlmodel, is based on arXiv’s article, "YOLO9000: Better, Faster, Stronger" by Joseph Redmon, Ali Farhadi (CVPR 2017).

 The following license applies to the source code, and other elements of this package:

 Copyright © 2020 Apple Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import AVFoundation
import UIKit
import Vision

internal class VisionObjectRecognitionViewController: ViewController {
    private var detectionOverlay: CALayer?

    // Vision parts
    private var requests = [VNRequest]()

    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError? = nil

        guard let modelURL = Bundle.main.url(forResource: "YOLOv3", withExtension: "mlmodelc") else {
            return NSError(
                domain: "VisionObjectRecognitionViewController",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel) { request, _ in
                DispatchQueue.main.async {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        self.drawVisionRequestResults(results)
                    }
                }
            }
            requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }

        return error
    }

    func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay!.sublayers = nil // remove all the old recognized objects
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            let objectBounds = VNImageRectForNormalizedRect(
                objectObservation.boundingBox,
                Int(bufferSize.width),
                Int(bufferSize.height))

            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)

            let textLayer = self.createTextSubLayerInBounds(
                objectBounds,
                identifier: topLabelObservation.identifier,
                confidence: topLabelObservation.confidence)
            shapeLayer.addSublayer(textLayer)
            detectionOverlay!.addSublayer(shapeLayer)
        }
        updateLayerGeometry()
        CATransaction.commit()
    }

    override func captureOutput(_: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from _: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        let exifOrientation = exifOrientationFromDeviceOrientation()

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print(error)
        }
    }

    override func setupAVCapture() {
        super.setupAVCapture()

        // setup Vision parts
        setupLayers()
        updateLayerGeometry()
        setupVision()

        // start the capture
        startCaptureSession()
    }

    func setupLayers() {
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        detectionOverlay!.name = "DetectionOverlay"
        detectionOverlay!.bounds = CGRect(
            x: 0.0,
            y: 0.0,
            width: bufferSize.width,
            height: bufferSize.height)
        detectionOverlay!.position = CGPoint(x: rootLayer!.bounds.midX, y: rootLayer!.bounds.midY)
        rootLayer!.addSublayer(detectionOverlay!)
    }

    func updateLayerGeometry() {
        let bounds = rootLayer!.bounds
        var scale: CGFloat

        let xScale: CGFloat = bounds.size.width / bufferSize.height
        let yScale: CGFloat = bounds.size.height / bufferSize.width

        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)

        // rotate the layer into screen orientation and scale and mirror
        detectionOverlay!.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        // center the layer
        detectionOverlay!.position = CGPoint(x: bounds.midX, y: bounds.midY)

        CATransaction.commit()
    }

    func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence:  %.2f", confidence))
        let largeFont = UIFont(name: "Helvetica", size: 24.0)!
        formattedString.addAttributes(
            [NSAttributedString.Key.font: largeFont],
            range: NSRange(location: 0, length: identifier.count))
        textLayer.string = formattedString
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        textLayer.shadowOpacity = 0.7
        textLayer.shadowOffset = CGSize(width: 2, height: 2)
        textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
        textLayer.contentsScale = 2.0 // retina rendering
        // rotate the layer into screen orientation and scale and mirror
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
        return textLayer
    }

    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
        shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
}
