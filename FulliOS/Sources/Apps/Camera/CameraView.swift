//
//  CameraView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 8/6/2024.
//

import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

internal struct CameraView: View {
    @StateObject private var camera = CameraViewModel()
    @State private var showingFilters = false
    @State private var selectedFilter: CIFilter = .sepiaTone()
    @State private var capturedImage: UIImage?

    var body: some View {
        VStack {
            CameraPreview(camera: camera)
                .gesture(
                    MagnificationGesture()
                        .onChanged { val in
                            camera.zoom(factor: val)
                        })
                .onAppear {
                    camera.setup()
                }
                .alert(isPresented: $camera.showAlert) {
                    Alert(title: Text("Error"), message: Text(camera.alertMessage), dismissButton: .default(Text("OK")))
                }

            HStack {
                Button(action: camera.switchCamera) {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                }

                Spacer()
                Button(action: {
                    camera.capturePhoto { image in
                        capturedImage = image
                        showingFilters.toggle()
                    }
                }) {
                    Image(systemName: "camera.circle.fill")
                        .font(.system(size: 70))
                }

                Spacer()
                Button(action: camera.toggleFlash) {
                    Image(systemName: camera.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingFilters) {
            CameraFilterView(image: capturedImage, selectedFilter: $selectedFilter)
        }
    }
}
