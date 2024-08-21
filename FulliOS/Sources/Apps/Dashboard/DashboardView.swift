//
//  DashboardView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/5/2024.
//

import SwiftUI

internal struct AppsDashboard: View {
    let persistenceController = CoreDataStack.shared

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
            destinationView: AnyView(ObjectRecognitionView())),

        DashboardMenuItem(
            iconName: R.image.nfc.name,
            title: "NFC Reader (CoreNFC)",
            destinationView: AnyView(NFCReaderView())),

        DashboardMenuItem(
            iconName: R.image.unity.name,
            title: "Unity Game (Unity3D)",
            destinationView: AnyView(UnityGameView())),

        DashboardMenuItem(
            iconName: R.image.speech.name,
            title: "Speech Recognition (Speech)",
            destinationView: AnyView(SpeechRecognitionView())),

        DashboardMenuItem(
            iconName: R.image.notifications.name,
            title: "Local Notifications (UserNotifications)",
            destinationView: AnyView(LocalNotificationsView())),

        DashboardMenuItem(
            iconName: R.image.files.name,
            title: "File Manager (SwiftUI)",
            destinationView: AnyView(FileManagerView())),

        DashboardMenuItem(
            iconName: R.image.widgets.name,
            title: "Add Widget (WidgetKit)",
            destinationView: AnyView(WidgetKitView())),

        DashboardMenuItem(
            iconName: R.image.haptic.name,
            title: "Haptic Feedback (CoreHaptics)",
            destinationView: AnyView(HapticFeedbackView())),

        DashboardMenuItem(
            iconName: R.image.quiz.name,
            title: "iOS Dev Quiz (ResearchKit)",
            destinationView: AnyView(DevQuizView())),

        DashboardMenuItem(
            iconName: R.image.employee.name,
            title: "Manage Employees (CoreData)",
            destinationView: AnyView(ManageEmployeesView())),

        DashboardMenuItem(
            iconName: R.image.web.name,
            title: "Web Browser (WebKit)",
            destinationView: AnyView(WebBrowserView())),

        DashboardMenuItem(
            iconName: R.image.tensorflow.name,
            title: "Image Classification (TensorFlowLite)",
            destinationView: AnyView(ImageClassificationView())),

        DashboardMenuItem(
            iconName: R.image.editing.name,
            title: "Audio/Video Editor (FFmpegKit)",
            destinationView: AnyView(AudioVideoEditorView())),

        DashboardMenuItem(
            iconName: R.image.bluetooth.name,
            title: "Bluetooth Manager (CoreBluetooth)",
            destinationView: AnyView(BluetoothView())),

        DashboardMenuItem(
            iconName: R.image.scan.name,
            title: "Document Scanner (PDFKit, VisionKit)",
            destinationView: AnyView(DocumentScanner())),

        DashboardMenuItem(
            iconName: R.image.website.name,
            title: "Website Reader (SwiftSoup, Kingfisher)",
            destinationView: AnyView(WebsiteReaderView())),

        DashboardMenuItem(
            iconName: R.image.health.name,
            title: "Health (HealthKit)",
            destinationView: AnyView(HealthKitView())),

        DashboardMenuItem(
            iconName: R.image.react.name,
            title: "React Native (React Native)",
            destinationView: AnyView(EmptyView())),

        DashboardMenuItem(
            iconName: R.image.animations.name,
            title: "Lottie Animations (Lottie)",
            destinationView: AnyView(LottieAnimationsView())),

        DashboardMenuItem(
            iconName: R.image.accelerate.name,
            title: "Accelerate Showcase (Accelerate)",
            destinationView: AnyView(AccelerateShowcaseView())),

        DashboardMenuItem(
            iconName: R.image.analyzer.name,
            title: "Text Analyzer (Rust Lib)",
            destinationView: AnyView(TextAnalyzerView())),

        DashboardMenuItem(
            iconName: R.image.server.name,
            title: "Web Server (GCDWebServer)",
            destinationView: AnyView(WebServerView())),

        DashboardMenuItem(
            iconName: R.image.fourier.name,
            title: "Fourier Transform (C Lib)",
            destinationView: AnyView(FourierTransformView())),

        DashboardMenuItem(
            iconName: R.image.graphql.name,
            title: "GraphQL Client (Apollo)",
            destinationView: AnyView(LaunchesView())),

        DashboardMenuItem(
            iconName: R.image.postgres.name,
            title: "Postgres Client (PostgresClientKit)",
            destinationView: AnyView(PostgresClientView())),

        DashboardMenuItem(
            iconName: R.image.album.name,
            title: "Albums List (SwiftUI, Alamofire, VIPER)",
            destinationView: AnyView(AlbumsListView())),

        DashboardMenuItem(
            iconName: R.image.gemini.name,
            title: "Gemini Chat (Gemini, URLSession)",
            destinationView: AnyView(GeminiChatView())),

        DashboardMenuItem(
            iconName: R.image.meal.name,
            title: "Meals Search (MVVMC, Moya)",
            destinationView: AnyView(MealsSearchView())),

        DashboardMenuItem(
            iconName: R.image.expense.name,
            title: "Expenses Manager (FLUX, Alamofire)",
            destinationView: AnyView(ExpensesManagerView())),

        DashboardMenuItem(
            iconName: R.image.student.name,
            title: "Students Manager (ReactorKit, RxSwift)",
            destinationView: AnyView(StudentsManagerView())),

        DashboardMenuItem(
            iconName: R.image.election.name,
            title: "Manage Election Candidates (TCA, Moya)",
            destinationView: AnyView(ElectionCandidatesView()))
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
