//
//  DrawingArea.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 24/6/2024.
//

import Foundation
import SwiftUI

internal struct DrawingArea: View {
    @ObservedObject var drawingData: DrawingData
    var selectedColor: Color

    var body: some View {
        GeometryReader { _ in
            Path { path in
                for line in drawingData.lines {
                    addLine(to: &path, line: line)
                }
            }
            .stroke(selectedColor, lineWidth: 2)
            .background(Color.white)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let newPoint = Line.Point(x: value.location.x, y: value.location.y)
                        drawingData.addPoint(newPoint)
                    }
                    .onEnded { _ in
                        drawingData.addNewLine()
                    })
        }
    }

    private func addLine(to path: inout Path, line: Line) {
        let points = line.points
        guard let firstPoint = points.first else {
            return
        }
        path.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
        for point in points.dropFirst() {
            path.addLine(to: CGPoint(x: point.x, y: point.y))
        }
    }
}
