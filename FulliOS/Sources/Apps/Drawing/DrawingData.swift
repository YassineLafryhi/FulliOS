//
//  DrawingData.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 24/6/2024.
//

internal struct Line {
    var points: [Point]

    struct Point {
        let x: CGFloat
        let y: CGFloat
    }
}

internal class DrawingData: ObservableObject {
    @Published var lines: [Line] = []
    private var currentLine = Line(points: [])

    func addPoint(_ point: Line.Point) {
        currentLine.points.append(point)
        lines += [currentLine]
    }

    func addNewLine() {
        currentLine = Line(points: [])
    }

    func getImage() -> UIImage? {
        let canvasSize = CGSize(width: 1_024, height: 768)

        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        for line in lines {
            guard let firstPoint = line.points.first else { continue }

            context.beginPath()
            context.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))

            for point in line.points.dropFirst() {
                context.addLine(to: CGPoint(x: point.x, y: point.y))
            }

            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(2)
            context.strokePath()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
