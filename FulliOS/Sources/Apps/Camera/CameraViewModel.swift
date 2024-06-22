//
//  CameraViewModel.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 8/6/2024.
//

import AVFoundation

internal class CameraViewModel: NSObject, ObservableObject {
    public let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var currentDevice: AVCaptureDevice?
    @Published var isFlashOn = false
    @Published var showAlert = false
    var alertMessage = ""

    override init() {
        super.init()
    }

    func setup() {
        session.beginConfiguration()
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let input = try? AVCaptureDeviceInput(device: device!) else { return }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        session.commitConfiguration()

        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }

        currentDevice = device
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = isFlashOn ? .on : .off
        output.capturePhoto(with: settings, delegate: PhotoCaptureProcessor(completion: completion))
    }

    func switchCamera() {
        guard let currentInput = session.inputs.first as? AVCaptureDeviceInput else { return }
        session.beginConfiguration()
        session.removeInput(currentInput)
        let newDevice = (currentInput.device.position == .back) ? getFrontCamera() : getBackCamera()
        guard let newInput = try? AVCaptureDeviceInput(device: newDevice) else { return }
        if session.canAddInput(newInput) {
            session.addInput(newInput)
            currentDevice = newDevice
        } else {
            session.addInput(currentInput)
            currentDevice = currentInput.device
        }
        session.commitConfiguration()
    }

    func toggleFlash() {
        isFlashOn.toggle()
    }

    func zoom(factor: CGFloat) {
        guard let device = currentDevice else { return }
        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = max(1.0, min(factor, device.activeFormat.videoMaxZoomFactor))
            device.unlockForConfiguration()
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    private func getFrontCamera() -> AVCaptureDevice {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)!
    }

    private func getBackCamera() -> AVCaptureDevice {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!
    }
}
