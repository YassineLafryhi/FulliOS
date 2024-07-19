//
//  DrawingView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 24/6/2024.
//

import SwiftUI

internal struct DrawingView: View {
    @State private var selectedColor: Color = .black
    @StateObject private var drawingData = DrawingData()

    var body: some View {
        VStack {
            ColorPicker("Choose your color", selection: $selectedColor)
                .padding()

            DrawingArea(drawingData: drawingData, selectedColor: selectedColor)
                .background(Color.white)
                .border(Color.black, width: 1)

            FButton("Save as JPG") {
                saveImage(drawingData: drawingData)
            }
            .padding()
        }
    }

    private func saveImage(drawingData: DrawingData) {
        guard let image = drawingData.getImage() else {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Shared.defaultDateAndTimeFormatForNames
        let dateString = dateFormatter.string(from: Date())
        let filename = "\(dateString).jpg"

        if let data = image.jpegData(compressionQuality: 0.8) {
            let filePath = getDocumentsDirectory().appendingPathComponent(filename)
            try? data.write(to: filePath)
            Logger.shared.log("Saved to \(filePath)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
