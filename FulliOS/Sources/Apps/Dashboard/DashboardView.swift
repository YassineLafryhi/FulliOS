//
//  DashboardView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import SwiftUI

internal struct AppsDashboard: View {
    let menuItems: [DashboardMenuItem] = [
        DashboardMenuItem(
            iconName: R.image.swiftdata.name,
            title: "Contacts List (SwiftData)",
            destinationView: AnyView(SwiftDataContactsView())),

        DashboardMenuItem(
            iconName: R.image.kotlin.name,
            title: "Posts List(KMM)",
            destinationView: AnyView(KotlinMultiplatformView())),

        DashboardMenuItem(
            iconName: R.image.ocr.name,
            title: "OCR App (VisionKit)",
            destinationView: AnyView(OcrView())),

        DashboardMenuItem(
            iconName: R.image.face.name,
            title: "Face Detection (Vision)",
            destinationView: AnyView(FaceDetector())),

        DashboardMenuItem(
            iconName: R.image.quran.name,
            title: "Quran Player (AVFoundation)",
            destinationView: AnyView(QuranPlayerView())),

        DashboardMenuItem(
            iconName: R.image.flutter.name,
            title: "Counter (Flutter)",
            destinationView: AnyView(FlutterView())),

        DashboardMenuItem(
            iconName: R.image.opencv.name,
            title: "Process Image (OpenCV)",
            destinationView: AnyView(OpenCvView())),

        DashboardMenuItem(
            iconName: R.image.pdf.name,
            title: "PDF Viewer (PDFKit)",
            destinationView: AnyView(PDFViewer())),

        DashboardMenuItem(
            iconName: R.image.translation.name,
            title: "Text Translator (MLKit)",
            destinationView: AnyView(TextTranslator())),

        DashboardMenuItem(
            iconName: R.image.camera.name,
            title: "Camera (AVFoundation, CoreImage)",
            destinationView: AnyView(CameraView()))
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(menuItems.chunked(into: 2), id: \.self) { chunk in
                        HStack {
                            ForEach(chunk, id: \.title) { item in
                                FMenu(menuItem: item)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(hex: "#F8F8F8"))
            .onAppear {}
        }
    }
}
