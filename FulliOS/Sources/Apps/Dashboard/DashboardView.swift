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
            destinationView: AnyView(CameraView())),

        DashboardMenuItem(
            iconName: R.image.passwords.name,
            title: "Passwords (CryptoKit, RealmSwift)",
            destinationView: AnyView(PasswordsManager())),

        DashboardMenuItem(
            iconName: R.image.cosmonaut.name,
            title: "Cosmonaut Suit (RealityKit)",
            destinationView: AnyView(CosmonautSuitView())),

        DashboardMenuItem(
            iconName: R.image.drawing.name,
            title: "Drawing (SwiftUI - GeometryReader)",
            destinationView: AnyView(DrawingView())),

        DashboardMenuItem(
            iconName: R.image.geometry.name,
            title: "Geometry (SceneKit, CoreMotion)",
            destinationView: AnyView(SceneKitView())),

        DashboardMenuItem(
            iconName: R.image.temperature.name,
            title: "Temperature Chart (Charts, RxSwift)",
            destinationView: AnyView(TemperatureChartView())),

        DashboardMenuItem(
            iconName: R.image.qrcode.name,
            title: "Barcode & QR Code Scanning (AVFoundation)",
            destinationView: AnyView(QRCodeScannerView())),

        DashboardMenuItem(
            iconName: R.image.maps.name,
            title: "Maps (MapKit, CoreLocation)",
            destinationView: AnyView(MapsView())),

        DashboardMenuItem(
            iconName: R.image.microphone.name,
            title: "Sound Recorder (AVFoundation)",
            destinationView: AnyView(SoundRecorderView())),

        DashboardMenuItem(
            iconName: R.image.http.name,
            title: "HTTP Request Builder (Alamofire, MVVM)",
            destinationView: AnyView(HttpRequestBuilderView())),

        DashboardMenuItem(
            iconName: R.image.news.name,
            title: "News (UIKit, Alamofire, VIPER)",
            destinationView: AnyView(NewsView())),

        DashboardMenuItem(
            iconName: R.image.handwriting.name,
            title: "Handwriting Recognition (PencilKit, Vision)",
            destinationView: AnyView(HandwritingRecognitionView())),

        DashboardMenuItem(
            iconName: R.image.specification.name,
            title: "Device Info (DeviceKit, CoreMotion)",
            destinationView: AnyView(DeviceInfoView())),

        DashboardMenuItem(
            iconName: R.image.audio.name,
            title: "Audio Analyzer (SoundAnalysis, AVFoundation)",
            destinationView: AnyView(SoundAnalysisView())),

        DashboardMenuItem(
            iconName: R.image.object.name,
            title: "YOLOv3 Object Recognition (CoreML, Vision)",
            destinationView: AnyView(ObjectRecognitionView()))
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
