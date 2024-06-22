//
//  FaceManager.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 4/6/2024.
//

import UIKit
import Vision

internal class FaceManager {
    static let shared = FaceManager()

    private init() {}

    func detectFaces(in image: UIImage, completion: @escaping ([CGRect]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }

        let request = VNDetectFaceRectanglesRequest { request, error in
            guard error == nil, let results = request.results as? [VNFaceObservation] else {
                completion([])
                return
            }

            let faceRects = results.map { $0.boundingBox }
            completion(faceRects)
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        performVisionRequest(handler, with: request)
    }

    func detectFacialLandmarks(in image: UIImage, completion: @escaping ([VNFaceObservation]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }

        let request = VNDetectFaceLandmarksRequest { request, error in
            guard error == nil, let results = request.results as? [VNFaceObservation] else {
                completion([])
                return
            }

            completion(results)
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        performVisionRequest(handler, with: request)
    }

    private func performVisionRequest(_ handler: VNImageRequestHandler, with request: VNRequest) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                Logger.shared.log("Failed to perform Vision request: \(error)")
            }
        }
    }
}
