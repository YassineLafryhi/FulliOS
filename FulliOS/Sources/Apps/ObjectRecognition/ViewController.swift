/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 Contains the view controller for the Breakfast Finder.

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

internal class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer?

    private var previewView: UIView?
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let videoDataOutput = AVCaptureVideoDataOutput()

    private let videoDataOutputQueue = DispatchQueue(
        label: "VideoDataOutput",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)

    func captureOutput(_: AVCaptureOutput, didOutput _: CMSampleBuffer, from _: AVCaptureConnection) {
        // to be implemented in the subclass
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPreviewView()
        setupAVCapture()
    }

    func setupPreviewView() {
        previewView = UIView(frame: view.bounds)
        view.addSubview(previewView!)
        previewView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewView!.topAnchor.constraint(equalTo: view.topAnchor),
            previewView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupAVCapture() {
        var deviceInput: AVCaptureDeviceInput?

        // Select a video device, make an input
        let videoDevice = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }

        session.beginConfiguration()
        session.sessionPreset = .vga640x480 // Model image size is smaller.

        // Add a video input
        guard session.canAddInput(deviceInput!) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput!)
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput
                .videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        let captureConnection = videoDataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true
        do {
            try videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.commitConfiguration()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rootLayer = previewView!.layer
        previewLayer!.frame = rootLayer!.bounds
        rootLayer!.addSublayer(previewLayer!)
    }

    func startCaptureSession() {
        session.startRunning()
    }

    // Clean up capture setup
    func teardownAVCapture() {
        previewLayer!.removeFromSuperlayer()
        previewLayer = nil
    }

    func captureOutput(_: AVCaptureOutput, didDrop _: CMSampleBuffer, from _: AVCaptureConnection) {
        // print("frame dropped")
    }

    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation

        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown: // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft: // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight: // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait: // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
}
