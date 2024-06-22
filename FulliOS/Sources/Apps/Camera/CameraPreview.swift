//
//  CameraPreview.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 8/6/2024.
//

import AVFoundation
import SwiftUI

internal struct CameraPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }

    @ObservedObject var camera: CameraViewModel

    func makeUIView(context _: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.videoPreviewLayer.session = camera.session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_: VideoPreviewView, context _: Context) {}
}
